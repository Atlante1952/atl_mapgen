minetest.register_on_generated(function(minp, maxp, seed)
    if maxp.y < 0 or minp.y > 200 then
        return
    end

    local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
    local area = VoxelArea:new({MinEdge = emin, MaxEdge = emax})
    local data = vm:get_data()

    local heightmap = minetest.get_perlin_map({
        offset = 0,
        scale = 1,
        spread = {x = 300, y = 300, z = 300},
        seed = 5349,
        octaves = 6,
        persist = 0.7
    }, {x = maxp.x - minp.x + 1, y = maxp.z - minp.z + 1}):get2dMap_flat({x = minp.x, y = minp.z})

    local peakmap = minetest.get_perlin_map({
        offset = 0,
        scale = 1,
        spread = {x = 200, y = 200, z = 200},
        seed = 12345,
        octaves = 3,
        persist = 0.5
    }, {x = maxp.x - minp.x + 1, y = maxp.z - minp.z + 1}):get2dMap_flat({x = minp.x, y = minp.z})

    local plainmap = minetest.get_perlin_map({
        offset = 0,
        scale = 1,
        spread = {x = 1800, y = 1800, z = 1800},
        seed = 6789,
        octaves = 0,
        persist = 0
    }, {x = maxp.x - minp.x + 1, y = maxp.z - minp.z + 1}):get2dMap_flat({x = minp.x, y = minp.z})

    local terrain_type_map = minetest.get_perlin_map({
        offset = 0,
        scale = 1,
        spread = {x = 500, y = 500, z = 500},
        seed = 7890,
        octaves = 1,
        persist = 0.5
    }, {x = maxp.x - minp.x + 1, y = maxp.z - minp.z + 1}):get2dMap_flat({x = minp.x, y = minp.z})

    local desert_map = minetest.get_perlin_map({
        offset = 0,
        scale = 1,
        spread = {x = 1000, y = 1000, z = 1000},
        seed = 8765,
        octaves = 3,
        persist = 0.5
    }, {x = maxp.x - minp.x + 1, y = maxp.z - minp.z + 1}):get2dMap_flat({x = minp.x, y = minp.z})

    local forest_map = minetest.get_perlin_map({
        offset = 0,
        scale = 1,
        spread = {x = 800, y = 800, z = 800},
        seed = 9876,
        octaves = 3,
        persist = 0.5
    }, {x = maxp.x - minp.x + 1, y = maxp.z - minp.z + 1}):get2dMap_flat({x = minp.x, y = minp.z})

    local wetland_map = minetest.get_perlin_map({
        offset = 0,
        scale = 1,
        spread = {x = 1200, y = 1200, z = 1200},
        seed = 1098,
        octaves = 3,
        persist = 0.5
    }, {x = maxp.x - minp.x + 1, y = maxp.z - minp.z + 1}):get2dMap_flat({x = minp.x, y = minp.z})

    local snow_map = minetest.get_perlin_map({
        offset = 0,
        scale = 1,
        spread = {x = 1500, y = 1500, z = 1500},
        seed = 2098,
        octaves = 3,
        persist = 0.5
    }, {x = maxp.x - minp.x + 1, y = maxp.z - minp.z + 1}):get2dMap_flat({x = minp.x, y = minp.z})

    local tropical_forest_map = minetest.get_perlin_map({
        offset = 0,
        scale = 1,
        spread = {x = 1300, y = 1300, z = 1300},
        seed = 3098,
        octaves = 3,
        persist = 0.5
    }, {x = maxp.x - minp.x + 1, y = maxp.z - minp.z + 1}):get2dMap_flat({x = minp.x, y = minp.z})

    local beach_map = minetest.get_perlin_map({
        offset = 0,
        scale = 1,
        spread = {x = 1100, y = 1100, z = 1100},
        seed = 4098,
        octaves = 3,
        persist = 0.5
    }, {x = maxp.x - minp.x + 1, y = maxp.z - minp.z + 1}):get2dMap_flat({x = minp.x, y = minp.z})

    local grassland_map = minetest.get_perlin_map({
        offset = 0,
        scale = 1,
        spread = {x = 1400, y = 1400, z = 1400},
        seed = 5098,
        octaves = 3,
        persist = 0.5
    }, {x = maxp.x - minp.x + 1, y = maxp.z - minp.z + 1}):get2dMap_flat({x = minp.x, y = minp.z})

    local c_dirt_with_grass = minetest.get_content_id("default:dirt_with_grass")
    local c_dirt = minetest.get_content_id("default:dirt")
    local c_stone = minetest.get_content_id("default:stone")
    local c_water = minetest.get_content_id("default:water_source")
    local c_snow = minetest.get_content_id("default:snowblock")
    local c_sand = minetest.get_content_id("default:sand")
    local c_ice = minetest.get_content_id("default:ice")
    local c_desert_sand = minetest.get_content_id("default:desert_sand")
    local c_desert_stone = minetest.get_content_id("default:desert_stone")
    local c_forest_tree = minetest.get_content_id("default:tree")
    local c_wetland_water = minetest.get_content_id("default:water_source")
    local c_tropical_tree = minetest.get_content_id("default:jungletree")
    local c_beach_sand = minetest.get_content_id("default:sand")
    local c_grassland_grass = minetest.get_content_id("default:dirt_with_grass")

    local water_level = 1
    local snow_level = 100
    local sand_level = 3

    local ni = 1
    for z = minp.z, maxp.z do
        for x = minp.x, maxp.x do
            local base_height = math.floor(heightmap[ni] * 20 + 50)
            local peak_height = math.floor(peakmap[ni] * 100)
            local plain_height = math.floor(plainmap[ni] * 10)
            local terrain_type = terrain_type_map[ni]
            local desert_type = desert_map[ni]
            local forest_type = forest_map[ni]
            local wetland_type = wetland_map[ni]
            local snow_type = snow_map[ni]
            local tropical_forest_type = tropical_forest_map[ni]
            local beach_type = beach_map[ni]
            local grassland_type = grassland_map[ni]

            local terrain_height = base_height + (terrain_type * peak_height + (1 - terrain_type) * plain_height)

            ni = ni + 1

            for y = minp.y, maxp.y do
                local vi = area:index(x, y, z)

                if y <= terrain_height then
                    if y <= water_level then
                        data[vi] = c_water
                    elseif y <= terrain_height - 4 then
                        data[vi] = c_stone
                    elseif y == terrain_height and y <= sand_level then
                        data[vi] = c_sand
                    elseif y == terrain_height then
                        data[vi] = c_dirt_with_grass
                        if y - 1 >= minp.y then
                            data[area:index(x, y - 1, z)] = c_dirt
                        end
                        if y - 2 >= minp.y then
                            data[area:index(x, y - 2, z)] = c_stone
                        end
                    else
                        data[vi] = c_stone
                    end
                elseif y > terrain_height and y <= terrain_height + 1 and terrain_height > water_level then
                    if terrain_height > snow_level then
                        data[vi] = c_snow
                        if y - 1 >= minp.y then
                            data[area:index(x, y - 1, z)] = c_snow
                        end
                        if y - 2 >= minp.y then
                            data[area:index(x, y - 2, z)] = c_snow
                        end
                        if y - 3 >= minp.y then
                            data[area:index(x, y - 3, z)] = c_ice
                        end
                    end
                end

                if y > 150 and data[vi] == c_snow then
                    data[vi] = c_ice
                end

                if desert_type > 0.5 then
                    if y <= terrain_height then
                        data[vi] = c_desert_sand
                        if y - 1 >= minp.y then
                            data[area:index(x, y - 1, z)] = c_desert_sand
                        end
                        if y - 2 >= minp.y then
                            data[area:index(x, y - 2, z)] = c_desert_stone
                        end
                    end
                end

                if forest_type > 0.5 and y == terrain_height then
                    data[vi] = c_forest_tree
                end

                if snow_type > 0.5 and y == terrain_height then
                    data[vi] = c_snow
                end

                if tropical_forest_type > 0.5 and y == terrain_height then
                    data[vi] = c_tropical_tree
                end

                if beach_type > 0.5 and y == terrain_height then
                    data[vi] = c_beach_sand
                end

                if grassland_type > 0.5 and y == terrain_height then
                    data[vi] = c_grassland_grass
                end

                -- Place dirt_with_grass or snow above stone if there is air
                if y > 0 and y < maxp.y and data[vi] == c_stone then
                    local vi_above = area:index(x, y + 1, z)
                    if data[vi_above] == minetest.CONTENT_AIR then
                        if terrain_height > snow_level then
                            data[vi] = c_snow
                        else
                            data[vi] = c_dirt_with_grass
                        end
                    end
                end
            end
        end
    end

    vm:set_data(data)
    vm:write_to_map()
    vm:update_map()
end)

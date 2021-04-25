FUEL = true
-- eats all fuel in inventory
-- returns true if ate some fuel else false
function fuel()
    cur = turtle.getSelectedSlot()
    fueled = false
    for x = 1, 16, 1 do
        turtle.select(x)
        if turtle.refuel() then
            fueled = true
        end
    end
    turtle.select(cur)
    return fueled
end


-- turns right by default else left
function turn(flip)
    if flip then
        turtle.turnLeft()
    else
        turtle.turnRight()
    end
end


-- advances in a line either 'u'p 'd'own or 'f'orwards
-- returns true if complete else false
function advance(num, direction)
    for i = 1, num, 1 do
        -- refuel if out else end
        if turtle.getFuelLevel() == 0 then
            if not fuel() then
                if FUEL then
                    print("OUT OF FUEL")
                    FUEL = false
                end
                return false
            end
        end

        if direction == "f" then
            b, s = turtle.dig()
        elseif direction == "u" then
            b, s = turtle.digUp()
        elseif direction == "d" then
            b, s = turtle.digDown()
        else
            return false
        end

        if not b and not s == "Nothing to dig here" then
            print(s)
            return false
        end

        if direction == "f" then
            b, s = turtle.forward()
        elseif direction == "u" then
            b, s = turtle.up()
        elseif direction == "d" then
            b, s = turtle.down()
        else
            return false
        end

    end
    return true
end


-- returns turtle to start given quarry size and last flip
-- could easily be rewritten to calculate flips based on odd/even
-- but for now this is just a copy-paste from quarry()
function home(L, W, D, flipW, flipD)
    --rise
    for _ = 2, D do
        if flipD then
            turtle.down()
        else
            turtle.up()
        end
    end
    -- if depth isn't even it'll be in far back or far side corner
    if D % 2 ~= 0 then
        turn(not flipW)
        for _ = 2, W do
            turtle.forward()
        end
        -- if odd it's always far back and needs to move more and turn opposite
        if W % 2 ~= 0 then
            turn(not flipW)
            for _ = 2, L do
                turtle.forward()
            end
        else
            turn(flipW)
        end
    end

    -- back to start
    turtle.forward()
    turtle.turnLeft()
    turtle.turnLeft()
end


-- do the stuff
function quarry(L, W, D)
    -- check if flipped
    flipW = false
    flipD = false
    if W < 0 then
        W = 0 - W
        flipW = true
    end
    if D < 0 then
        D = 0 - D
        flipD = true
    end

    -- move into first block
    if not advance(1, 'f') then return false end

    --main loop
    -- iter depth
    for cD = 1, D do
        --iter columns (width)
        for cW = 1, W do
            -- dig a line
            if not advance(L-1, 'f') then return false end

            --if not last, turn into next line
            if cW ~= W then
                turn(flipW)
                if not advance(1, 'f') then return false end
                turn(flipW)
                flipW = not flipW
            end
        end

        -- flip 180 and dig down/up, then start next layer
        if cD ~= D then
            turtle.turnLeft()
            turtle.turnLeft()
            if flipD then
                if not advance(1, 'u') then return false end
            else
                if not advance(1, 'd') then return false end
            end
        end

    end
    home(L, W, D, flipW, flipD)
    return true
end


function main ()
    print("Quarry Length (forwards. starts 1 block ahead of turtle): ")
    Ql = read()
    print("Quarry Width (pos for right, neg for left): ")
    Qw = read()
    print("Quarry Depth (pos for down, neg for up): ")
    Qd = read()
    quarry(tonumber(Ql), tonumber(Qw), tonumber(Qd))
end

main()

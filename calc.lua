local var = {
    value = 0
}

function var:round(num)
    if num >= 0 then
        value = math.floor(num + 0.5)
    else
        value = math.ceil(num - 0.5)
    end
    return value
end 

return var
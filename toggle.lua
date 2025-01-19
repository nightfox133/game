local ToggleVar = {}

-- function to create a new instance of ToggleVar
function ToggleVar:new(initial_value)
    local instance = {
        value = initial_value or false  -- Default to false if not provided
    }

    -- Add methods directly to the instance
    instance.set = function(self, b)
        self.value = b
    end

    instance.toggle = function(self)
        self.value = not self.value
    end

    instance.get = function(self)
        return self.value
    end

    return instance
end

return ToggleVar

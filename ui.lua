local ui = {} ui.__index = ui

ui.notification = function(head, body, ico)
    gui.notify:add(gui.notification(head, body, ico))
end

-- third world enum :pog:
ui.control = {
    checkbox = 1,
    slider = 2,
    selectable = 3,
    button = 4,
    color_picker = 5,
    spacer = 6,
    text_input = 7,
    combo_box = 8,
    image = 9
}

-- we reimplementing functions ladies and gentlemen
local control_meta = {}
control_meta.__index = control_meta
control_meta.object = nil
control_meta.control = nil
control_meta.type = nil
control_meta.container = nil

function control_meta:get(...)
    local arg_table = { ... }
    local return_param = arg_table[1] -- optional first argument

    local success, value, param_object = pcall(function()
        local param_object = self.control:get_value()

        if (param_object ~= nil) then
            return param_object:get(), param_object -- return value and the param_object if they need it for whatever reason
        end
    end)

    if (return_param) then
        return value, param_object
    else
        return value
    end
end

function control_meta:set(...)
    local arg_table = { ... } -- only one argument needed for now but we futureproofing this bitch

    -- check for control objects with a set_value func first
    if (self.type == ui.control.checkbox) then
        self.control:set_value(arg_table[1])
    elseif (self.type == ui.control.text_input) then
        self.control:set_value(arg_table[1])
    else -- guess we directly setting value_param then
        pcall(function()
            local param_object = self.control:get_value()
            
            if (param_object ~= nil) then
                param_object:set(arg_table[1])
            end
        end)
    end
end

function control_meta:delete()
    self.container:remove(self.object)
end

function control_meta:callback(fn)
    self.control:add_callback(fn)
end

ui.find_group = function(path)
    return gui.ctx:find(path)
end

ui.add_control = function(control_type, control_id, label, group, ...)
    local arg_table = { ... }

    control_id = gui.control_id(control_id)
    local control_obj = {}

    setmetatable(control_obj, control_meta)
    
    -- no switch statements :(
    if (control_type == ui.control.checkbox) then
        control_obj.control = gui.checkbox(control_id)
        control_obj.object = gui.make_control(label, control_obj.control)
    end

    control_obj.type = control_type
    control_obj.container = group

    group:add(control_obj.object)
    group:reset()

    return control_obj
end

ui.remove_control = function(control_obj)
    control_obj:delete()
end

ui.add_callback = function(control_obj, fn)
    control_obj:callback(fn)
end

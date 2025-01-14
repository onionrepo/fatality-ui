local ui = {} ui.__index = ui
local control_meta = { object, control, type, container, blocked = false } control_meta.__index = control_meta

ui.notification = function(head, body, ico)
    gui.notify:add(gui.notification(head, body, ico))
end

function control_meta:get(...)
    if (self.blocked) then return end

    local arg_table = { ... }
    local return_param = arg_table[1]
    local param_object = self.control:get_value()

    if (param_object ~= nil) then
        return param_object:get(), param_object
    end
end

function control_meta:set(...)
    if (self.blocked) then return end

    local arg_table = { ... }

    if (self.type == ui.control.checkbox or self.type == ui.control.text_input) then
        self.control:set_value(arg_table[1])
    else
        local param_object = self.control:get_value()
        
        if (param_object ~= nil) then
            param_object:set(arg_table[1])
        end
    end
end

ui.find_group = function(path)
    return gui.ctx:find(path)
end

ui.control = {
    checkbox = { enum = 1, blocked = false, args = 1, func = gui.checkbox },
    slider = { enum = 2, blocked = false, args = 4, func = gui.slider },
    selectable = { enum = 3, blocked = true, args = 1, func = gui.selectable },
    button = { enum = 4, blocked = true, args = 1, func = gui.button },
    color_picker = { enum = 5, blocked = false, args = 1, func = gui.color_picker },
    spacer = { enum = 6, blocked = true, args = 0, func = gui.spacer },
    text_input = { enum = 7, blocked = false, args = 0, func = gui.text_input },
    combo_box = { enum = 8, blocked = false, args = 0, func = gui.combo_box },
    image = { enum = 9, blocked = true, args = 1, func = gui.image }
}

ui.add_control = function(control_type, control_id, label, group, ...)
    local arg_table, control_obj = { ... }, {}

    control_id = gui.control_id(control_id)
    setmetatable(control_obj, control_meta)

    for k, v in pairs(ui.control) do
        if (v.enum == control_type.enum) then
            control_obj.blocked = v.blocked
            control_obj.control = v.func(control_id, unpack(arg_table))
        end
    end

    control_obj.object = gui.make_control(label, control_obj.control)
    control_obj.type, control_obj.container = control_type, group

    group:add(control_obj.object)
    group:reset()

    return control_obj
end

ui.remove_control = function(control_obj)
    control_obj.container:remove(control_obj.object)
end

ui.add_callback = function(control_obj, fn)
    control_obj.control:add_callback(fn)
end

local ui = {} ui.__index = ui

ui.notification = function(head, body, ico)
    gui.notify:add(gui.notification(head, body, ico))
end

local control_meta = { object, control, type, container, cant_get = false, cant_set = false }
control_meta.__index = {}

function control_meta:get(...)
    if (self.cant_get) then
        return
    end

    local arg_table = { ... }
    local return_param = arg_table[1]

    local success, value, param_object = pcall(function()
        local param_object = self.control:get_value()

        if (param_object ~= nil) then
            return param_object:get(), param_object
        end
    end)

    if (return_param) then
        return value, param_object
    else
        return value
    end
end

function control_meta:set(...)
    if (self.cant_set) then
        return
    end

    local arg_table = { ... }

    if (self.type == ui.control.checkbox) then
        self.control:set_value(arg_table[1])
    elseif (self.type == ui.control.text_input) then
        self.control:set_value(arg_table[1])
    else
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

ui.add_control = function(control_type, control_id, label, group, ...)
    local arg_table = { ... }

    control_id = gui.control_id(control_id)
    local control_obj = {}

    setmetatable(control_obj, control_meta)

    if (control_type == ui.control.checkbox) then
        control_obj.control = gui.checkbox(control_id)
    elseif (control_type == ui.control.slider) then
        control_obj.control = gui.slider(control_id, arg_table[1], arg_table[2], arg_table[3], arg_table[4])
    elseif (control_type == ui.control.selectable) then
        control_obj.control = gui.selectable(control_id, arg_table[1])
        control_obj.cant_get = true
        control_obj.cant_set = true
    elseif (control_type == ui.control.button) then
        control_obj.control = gui.button(control_id, arg_table[1])
        control_obj.cant_get = true
        control_obj.cant_set = true
    elseif (control_type == ui.control.color_picker) then
        control_obj.control = gui.color_picker(control_id, arg_table[1])
    elseif (control_type == ui.control.spacer) then
        control_obj.control = gui.spacer(control_id)
        control_obj.cant_get = true
        control_obj.cant_set = true
    elseif (control_type == ui.control.text_input) then
        control_obj.control = gui.text_input(control_id)
    elseif (control_type == ui.control.combo_box) then
        control_obj.control = gui.combo_box(control_id)
    elseif (control_type == ui.control.image) then
        control_obj.control = gui.image(control_id, arg_table[1])
        control_obj.cant_get = true
        control_obj.cant_set = true
    end

    control_obj.object = gui.make_control(label, control_obj.control)
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

# Documentation

## Usage
```lua
local test_group = ui.find_group("lua>elements b")

-- Button example
local test_button = ui.add_control(ui.control.button, "test_button", "Test Button", test_group, "Test")

ui.add_callback(test_control, function()
    print("Callback test")
end)

-- Checkbox example
local test_checkbox = ui.add_control(ui.control.checkbox, "test_checkbox", "Test Checkbox", test_group)

ui.add_callback(test_checkbox, function()
    print("Checkbox test", test_checkbox:get())
    -- Checkbox test false

    test_checkbox:set(true)
    print("Checkbox test", test_checkbox:get())
    -- Checkbox test true
end)
```

## Enums
### ui.control
Accessed via ui.control.{var}

| Name |   |   |
| ---- | - | - |
| checkbox | slider | selectable |
| button | color_picker | spacer |
| text_input | combo_box | image |

## Metatables
### control_meta
Accessed via returned_control.{var}

| Field | Type | Description |
| ---- | ---- | ----------- |
| object | layout | Layout object for the created control (available in API docs). |
| control | control | Control object for the created control (available in API docs). |
| type | ui.control | Enum for the control the metatable represents. |
| container | container | Container object that the created control is within (available in API docs). |
| cant_get | bool | Internal field to block user from improperly reading control values. |
| cant_set | bool | Internal field to block user from improperly setting control values. |

## Functions
### ui.find_group

| Name | Type | Description |
| ---- | ---- | ----------- |
| path | string | Alias control for gui.ctx:find, path to a container object. |

### ui.add_control

| Name | Type | Description |
| ---- | ---- | ----------- |
| control_type | int | Type of control from the ui.control enum* to create. |
| id | control_id | Control ID structure. |
| label | string | Displayed name for the control |
| group | container | Returned container object from ui.find_group |
| additional_args | ... | Any additional required arguments for a control through the default API |

### ui.remove_control

| Name | Type | Description |
| ---- | ---- | ----------- |
| control_obj | control_meta | Metatable returned from creation for the control you wish to remove. |

### ui.add_callback

| Name | Type | Description |
| ---- | ---- | ----------- |
| control_obj | control_meta | Metatable returned from creation for the control you wish to remove. |
| fn | function | Function to run when the control is interacted with. |

type classList;

[@bs.val] external document : Dom.element = "document";

[@bs.val] [@bs.scope "document"]
external get_element_by_id : string => Dom.element = "getElementById";

[@bs.get] external get_classlist : Dom.element => classList = "classList";

[@bs.send] external remove_class : (classList, string) => unit = "remove";

[@bs.send] external add_class : (classList, string) => unit = "add";

[@bs.send]
external add_event_listener : (Dom.element, string, Dom.event => unit) => unit =
  "addEventListener";

[@bs.get] external keycode : Dom.event => int = "keyCode";

[@bs.get] external which_key : Dom.event => int = "which";

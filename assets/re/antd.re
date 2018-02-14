let optBoolToOptJsBoolean =
  fun
  | None => None
  | Some(v) => Some(Js.Boolean.to_js_boolean(v));

let unwrapBool = v => Js.Undefined.from_opt @@ optBoolToOptJsBoolean(v);

module Button = {
  [%%bs.raw {| require('antd/lib/button/style/css'); |}];
  [@bs.module] external button : ReasonReact.reactClass = "antd/lib/button";
  let make =
      (
        ~type_=?,
        ~icon=?,
        ~className=?,
        ~size=?,
        ~style=?,
        ~htmlType=?,
        ~loading=?,
        ~id=?,
        ~shape=?,
        ~ghost=?,
        ~onClick=?,
        ~disabled=?,
        ~href=?
      ) =>
    ReasonReact.wrapJsForReason(
      ~reactClass=button,
      ~props=
        Js.Undefined.(
          {
            "type": from_opt(type_),
            "icon": from_opt(icon),
            "className": from_opt(className),
            "size": from_opt(size),
            "style": from_opt(style),
            "htmlType": from_opt(htmlType),
            "loading": from_opt(loading),
            "id": from_opt(id),
            "shape": from_opt(shape),
            "ghost": from_opt(ghost),
            "onClick": from_opt(onClick),
            "disabled": from_opt(disabled),
            "href": from_opt(href)
          }
        )
    );
};

module Layout = {
  [%%bs.raw {| require('antd/lib/layout/style/css'); |}];
  [@bs.module] external layout : ReasonReact.reactClass = "antd/lib/layout";
  let make = (~id=?, ~className=?, ~style=?) =>
    ReasonReact.wrapJsForReason(
      ~reactClass=layout,
      ~props=
        Js.Undefined.(
          {
            "id": from_opt(id),
            "className": from_opt(className),
            "style": from_opt(style)
          }
        )
    );
  module Header = {
    [@bs.module "antd/lib/layout"]
    external header : ReasonReact.reactClass = "Header";
    let make = (~id=?, ~className=?, ~style=?) =>
      ReasonReact.wrapJsForReason(
        ~reactClass=header,
        ~props=
          Js.Undefined.(
            {
              "id": from_opt(id),
              "className": from_opt(className),
              "style": from_opt(style)
            }
          )
      );
  };
  module Footer = {
    [@bs.module "antd/lib/layout"]
    external footer : ReasonReact.reactClass = "Footer";
    let make = (~id=?, ~className=?, ~style=?) =>
      ReasonReact.wrapJsForReason(
        ~reactClass=footer,
        ~props=
          Js.Undefined.(
            {
              "id": from_opt(id),
              "className": from_opt(className),
              "style": from_opt(style)
            }
          )
      );
  };
  module Content = {
    [@bs.module "antd/lib/layout"]
    external content : ReasonReact.reactClass = "Content";
    let make = (~id=?, ~className=?, ~style=?) =>
      ReasonReact.wrapJsForReason(
        ~reactClass=content,
        ~props=
          Js.Undefined.(
            {
              "id": from_opt(id),
              "className": from_opt(className),
              "style": from_opt(style)
            }
          )
      );
  };
  module Sider = {
    [@bs.module "antd/lib/layout"]
    external sider : ReasonReact.reactClass = "Sider";
    let make =
        (
          ~collapsedWidth=?,
          ~collapsible=?,
          ~breakpoint=?,
          ~width=?,
          ~className=?,
          ~style=?,
          ~id=?,
          ~defaultCollapsed=?,
          ~reverseArrow=?,
          ~onCollapse=?,
          ~trigger=?,
          ~collapsed=?
        ) =>
      ReasonReact.wrapJsForReason(
        ~reactClass=sider,
        ~props=
          Js.Undefined.(
            {
              "collapsedWidth": from_opt(collapsedWidth),
              "collapsible": unwrapBool(collapsible),
              "breakpoint": from_opt(breakpoint),
              "width": from_opt(width),
              "className": from_opt(className),
              "style": from_opt(style),
              "id": from_opt(id),
              "defaultCollapsed": unwrapBool(defaultCollapsed),
              "reverseArrow": unwrapBool(reverseArrow),
              "onCollapse": from_opt(onCollapse),
              "trigger": from_opt(trigger),
              "collapsed": unwrapBool(collapsed)
            }
          )
      );
  };
};

module Menu = {
  [%%bs.raw {| require('antd/lib/menu/style/css'); |}];
  [@bs.module] external menu : ReasonReact.reactClass = "antd/lib/menu";
  let make =
      (
        ~onOpenChange=?,
        ~selectedKeys=?,
        ~onSelect=?,
        ~mode=?,
        ~multiple=?,
        ~inlineIndent=?,
        ~className=?,
        ~style=?,
        ~theme=?,
        ~openAnimation=?,
        ~id=?,
        ~openKeys=?,
        ~defaultSelectedKeys=?,
        ~defaultOpenKeys=?,
        ~onDeselect=?,
        ~onClick=?,
        ~selectable=?,
        ~openTransitionName=?
      ) =>
    ReasonReact.wrapJsForReason(
      ~reactClass=menu,
      ~props=
        Js.Undefined.(
          {
            "onOpenChange": from_opt(onOpenChange),
            "selectedKeys": from_opt(selectedKeys),
            "onSelect": from_opt(onSelect),
            "mode": from_opt(mode),
            "multiple": from_opt(multiple),
            "inlineIndent": from_opt(inlineIndent),
            "className": from_opt(className),
            "style": from_opt(style),
            "theme": from_opt(theme),
            "openAnimation": from_opt(openAnimation),
            "id": from_opt(id),
            "openKeys": from_opt(openKeys),
            "defaultSelectedKeys": from_opt(defaultSelectedKeys),
            "defaultOpenKeys": from_opt(defaultOpenKeys),
            "onDeselect": from_opt(onDeselect),
            "onClick": from_opt(onClick),
            "selectable": from_opt(selectable),
            "openTransitionName": from_opt(openTransitionName)
          }
        )
    );
  module Divider = {
    [@bs.module "antd/lib/menu"]
    external divider : ReasonReact.reactClass = "Divider";
    let make = (~id=?, ~className=?, ~style=?, ~disabled=?) =>
      ReasonReact.wrapJsForReason(
        ~reactClass=divider,
        ~props=
          Js.Undefined.(
            {
              "id": from_opt(id),
              "className": from_opt(className),
              "style": from_opt(style),
              "disabled": unwrapBool(disabled)
            }
          )
      );
  };
  module Item = {
    [@bs.module "antd/lib/menu"]
    external item : ReasonReact.reactClass = "Item";
    let make = (~id=?, ~className=?, ~style=?, ~disabled=?, ~key=?) =>
      ReasonReact.wrapJsForReason(
        ~reactClass=item,
        ~props=
          Js.Undefined.(
            {
              "id": from_opt(id),
              "className": from_opt(className),
              "style": from_opt(style),
              "disabled": unwrapBool(disabled),
              "key": from_opt(key)
            }
          )
      );
  };
  module SubMenu = {
    [@bs.module "antd/lib/menu"]
    external subMenu : ReasonReact.reactClass = "SubMenu";
    let make =
        (
          ~disabled=?,
          ~key=?,
          ~title=?,
          ~children=?,
          ~onTitleClick=?,
          ~id=?,
          ~className=?,
          ~style=?
        ) =>
      ReasonReact.wrapJsForReason(
        ~reactClass=subMenu,
        ~props=
          Js.Undefined.(
            {
              "disabled": unwrapBool(disabled),
              "key": from_opt(key),
              "title": from_opt(title),
              "children": from_opt(children),
              "onTitleClick": from_opt(onTitleClick),
              "id": from_opt(id),
              "className": from_opt(className),
              "style": from_opt(style)
            }
          )
      );
  };
  module ItemGroup = {
    [@bs.module "antd/lib/menu"]
    external itemGroup : ReasonReact.reactClass = "ItemGroup";
    let make = (~id=?, ~className=?, ~style=?, ~title=?, ~children=?) =>
      ReasonReact.wrapJsForReason(
        ~reactClass=itemGroup,
        ~props=
          Js.Undefined.(
            {
              "id": from_opt(id),
              "className": from_opt(className),
              "style": from_opt(style),
              "title": from_opt(title),
              "children": from_opt(children)
            }
          )
      );
  };
};

module Breadcrumb = {
  [%%bs.raw {| require('antd/lib/breadcrumb/style/css'); |}];
  [@bs.module]
  external breadcrumb : ReasonReact.reactClass = "antd/lib/breadcrumb";
  let make =
      (
        ~routes=?,
        ~params=?,
        ~separator=?,
        ~itemRender=?,
        ~id=?,
        ~className=?,
        ~style=?
      ) =>
    ReasonReact.wrapJsForReason(
      ~reactClass=breadcrumb,
      ~props=
        Js.Undefined.(
          {
            "routes": from_opt(routes),
            "params": from_opt(params),
            "separator": from_opt(separator),
            "itemRender": from_opt(itemRender),
            "id": from_opt(id),
            "className": from_opt(className),
            "style": from_opt(style)
          }
        )
    );
  module Item = {
    [@bs.module "antd/lib/breadcrumb"]
    external item : ReasonReact.reactClass = "Item";
    let make = (~id=?, ~className=?, ~style=?, ~separator=?, ~href=?) =>
      ReasonReact.wrapJsForReason(
        ~reactClass=item,
        ~props=
          Js.Undefined.(
            {
              "id": from_opt(id),
              "className": from_opt(className),
              "style": from_opt(style),
              "separator": from_opt(separator),
              "href": from_opt(href)
            }
          )
      );
  };
};

module Upload = {
  [%%bs.raw {| require('antd/lib/upload/style/css'); |}];
  [@bs.module] external upload : ReasonReact.reactClass = "antd/lib/upload";
  let make =
      (
        ~withCredentials=?,
        ~multiple=?,
        ~defaultFileList=?,
        ~disabled=?,
        ~listType=?,
        ~name=?,
        ~className=?,
        ~headers=?,
        ~style=?,
        ~id=?,
        ~customRequest=?,
        ~showUploadList=?,
        ~action=?,
        ~supportServerRender=?,
        ~onChange=?,
        ~beforeUpload=?,
        ~onRemove=?,
        ~fileList=?,
        ~accept=?,
        ~onPreview=?,
        ~data=?
      ) =>
    ReasonReact.wrapJsForReason(
      ~reactClass=upload,
      ~props=
        Js.Undefined.(
          {
            "withCredentials": unwrapBool(withCredentials),
            "multiple": unwrapBool(multiple),
            "defaultFileList": from_opt(defaultFileList),
            "disabled": unwrapBool(disabled),
            "listtype_": from_opt(listType),
            "name": from_opt(name),
            "className": from_opt(className),
            "headers": from_opt(headers),
            "style": from_opt(style),
            "id": from_opt(id),
            "customRequest": from_opt(customRequest),
            "showUploadList": unwrapBool(showUploadList),
            "action": from_opt(action),
            "supportServerRender": unwrapBool(supportServerRender),
            "onChange": from_opt(onChange),
            "beforeUpload": from_opt(beforeUpload),
            "onRemove": from_opt(onRemove),
            "fileList": from_opt(fileList),
            "accept": from_opt(accept),
            "onPreview": from_opt(onPreview),
            "data": from_opt(data)
          }
        )
    );
};

module Message = {
  type content = string;
  type duration = int;
  type options;
  type callback = [@bs] (unit => unit);
  [%%bs.raw {| require('antd/lib/message/style/css'); |}];
  [@bs.module "antd/lib/message"]
  external success : (content, duration) => unit = "";
  [@bs.module "antd/lib/message"]
  external error : (content, duration) => unit = "";
  [@bs.module "antd/lib/message"]
  external info : (content, duration) => unit = "";
  [@bs.module "antd/lib/message"]
  external warning : (content, duration) => unit = "";
  [@bs.module "antd/lib/message"]
  external warn : (content, duration) => unit = "";
  [@bs.module "antd/lib/message"]
  external loading : (content, duration) => unit = "";
  [@bs.module "antd/lib/message"] external config : options => unit = "";
  [@bs.module "antd/lib/message"] external destroy : unit => unit = "";
};

module Alert = {
  [%%bs.raw {| require('antd/lib/alert/style/css'); |}];
  [@bs.module] external alert : ReasonReact.reactClass = "antd/lib/alert";
  let make =
      (
        ~description=?,
        ~closable=?,
        ~banner=?,
        ~onClose=?,
        ~type_=?,
        ~showIcon=?,
        ~className=?,
        ~style=?,
        ~id=?,
        ~closeText=?,
        ~message=?
      ) =>
    ReasonReact.wrapJsForReason(
      ~reactClass=alert,
      ~props=
        Js.Undefined.(
          {
            "description": from_opt(description),
            "closable": unwrapBool(closable),
            "banner": unwrapBool(banner),
            "onClose": from_opt(onClose),
            "type": from_opt(type_),
            "showIcon": unwrapBool(showIcon),
            "className": from_opt(className),
            "style": from_opt(style),
            "id": from_opt(id),
            "closeText": from_opt(closeText),
            "message": from_opt(message)
          }
        )
    );
};

module Progress = {
  [%%bs.raw {| require('antd/lib/progress/style/css'); |}];
  [@bs.module]
  external progress : ReasonReact.reactClass = "antd/lib/progress";
  let make =
      (
        ~format=?,
        ~gapDegree=?,
        ~width=?,
        ~type_=?,
        ~className=?,
        ~style=?,
        ~status=?,
        ~strokeWidth=?,
        ~id=?,
        ~percent=?,
        ~showInfo=?,
        ~gapPosition=?
      ) =>
    ReasonReact.wrapJsForReason(
      ~reactClass=progress,
      ~props=
        Js.Undefined.(
          {
            "format": from_opt(format),
            "gapDegree": from_opt(gapDegree),
            "width": from_opt(width),
            "type": from_opt(type_),
            "className": from_opt(className),
            "style": from_opt(style),
            "status": from_opt(status),
            "strokeWidth": from_opt(strokeWidth),
            "id": from_opt(id),
            "percent": from_opt(percent),
            "showInfo": unwrapBool(showInfo),
            "gapPosition": from_opt(gapPosition)
          }
        )
    );
};

module Row = {
  [%%bs.raw {| require('antd/lib/row/style/css'); |}];
  [@bs.module] external row : ReasonReact.reactClass = "antd/lib/row";
  let make =
      (
        ~type_=?,
        ~gutter=?,
        ~align=?,
        ~justify=?,
        ~id=?,
        ~className=?,
        ~style=?
      ) =>
    ReasonReact.wrapJsForReason(
      ~reactClass=row,
      ~props=
        Js.Undefined.(
          {
            "type": from_opt(type_),
            "gutter": from_opt(gutter),
            "align": from_opt(align),
            "justify": from_opt(justify),
            "id": from_opt(id),
            "className": from_opt(className),
            "style": from_opt(style)
          }
        )
    );
};

module Col = {
  [%%bs.raw {| require('antd/lib/col/style/css'); |}];
  [@bs.module] external col : ReasonReact.reactClass = "antd/lib/col";
  let make =
      (
        ~push=?,
        ~lg=?,
        ~offset=?,
        ~sm=?,
        ~xs=?,
        ~className=?,
        ~style=?,
        ~id=?,
        ~order=?,
        ~xl=?,
        ~pull=?,
        ~md=?,
        ~span=?
      ) =>
    ReasonReact.wrapJsForReason(
      ~reactClass=col,
      ~props=
        Js.Undefined.(
          {
            "push": from_opt(push),
            "lg": from_opt(lg),
            "offset": from_opt(offset),
            "sm": from_opt(sm),
            "xs": from_opt(xs),
            "className": from_opt(className),
            "style": from_opt(style),
            "id": from_opt(id),
            "order": from_opt(order),
            "xl": from_opt(xl),
            "pull": from_opt(pull),
            "md": from_opt(md),
            "span": from_opt(span)
          }
        )
    );
};

module Popover = {
  [%%bs.raw {| require('antd/lib/popover/style/css'); |}];
  [@bs.module] external popover : ReasonReact.reactClass = "antd/lib/popover";
  let make =
      (
        ~id=?,
        ~className=?,
        ~style=?,
        ~title=?,
        ~content=?,
        ~trigger=?,
        ~placement=?
      ) =>
    ReasonReact.wrapJsForReason(
      ~reactClass=popover,
      ~props=
        Js.Undefined.(
          {
            "id": from_opt(id),
            "className": from_opt(className),
            "style": from_opt(style),
            "title": from_opt(title),
            "content": from_opt(content),
            "trigger": from_opt(trigger),
            "placement": from_opt(placement)
          }
        )
    );
};

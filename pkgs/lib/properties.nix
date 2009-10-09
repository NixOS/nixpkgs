# Nixpkgs/NixOS properties.  Generalize the problem of delayable (not yet
# evaluable) properties like mkIf.

let lib = import ./default.nix; in

with { inherit (builtins) head tail; };
with import ./trivial.nix;
with import ./lists.nix;
with import ./misc.nix;
with import ./attrsets.nix;

rec {

  inherit (lib) typeOf;

  # Tell that nothing is defined.  When properties are evaluated, this type
  # is used to remove an entry.  Thus if your property evaluation semantic
  # implies that you have to mute the content of an attribute, then your
  # property should produce this value.
  isNotdef = attrs: (typeOf attrs) == "notdef";
  mkNotdef = {_type = "notdef";};

  # General property type, it has a property attribute and a content
  # attribute.  The property attribute refers to an attribute set which
  # contains a _type attribute and a list of functions which are used to
  # evaluate this property.  The content attribute is used to stack properties
  # on top of each other.
  # 
  # The optional functions which may be contained in the property attribute
  # are:
  #  - onDelay: run on a copied property.
  #  - onGlobalDelay: run on all copied properties.
  #  - onEval: run on an evaluated property.
  #  - onGlobalEval: run on a list of property stack on top of their values.
  isProperty = attrs: (typeOf attrs) == "property";
  mkProperty = p@{property, content, ...}: p // {
    _type = "property";
  };

  # Go through the stack of properties and apply the function `op' on all
  # property and call the function `nul' on the final value which is not a
  # property.  The stack is traversed in reversed order.  The `op' function
  # should expect a property with a content which have been modified.
  # 
  # Warning: The `op' function expects only one argument in order to avoid
  # calls to mkProperties as the argument is already a valid property which
  # contains the result of the folding inside the content attribute.
  foldProperty = op: nul: attrs:
    if isProperty attrs then
      op (attrs // {
        content = foldProperty op nul attrs.content;
      })
    else
      nul attrs;

  # Simple function which can be used as the `op' argument of the
  # foldProperty function.  Properties that you don't want to handle can be
  # ignored with the `id' function.  `isSearched' is a function which should
  # check the type of a property and return a boolean value.  `thenFun' and
  # `elseFun' are functions which behave as the `op' argument of the
  # foldProperty function.
  foldFilter = isSearched: thenFun: elseFun: attrs:
    if isSearched attrs.property then
      thenFun attrs
    else
      elseFun attrs;


  # Move properties from the current attribute set to the attribute
  # contained in this attribute set.  This trigger property handlers called
  # `onDelay' and `onGlobalDelay'.
  delayProperties = attrs:
    let cleanAttrs = rmProperties attrs; in
    if isProperty attrs then
      lib.mapAttrs (a: v:
        lib.addErrorContext "while moving properties on the attribute `${a}'." (
          triggerPropertiesGlobalDelay a (
            triggerPropertiesDelay a (
              copyProperties attrs v
      )))) cleanAttrs
    else
      attrs;

  # Call onDelay functions.
  triggerPropertiesDelay = name: attrs:
    let
      callOnDelay = p@{property, ...}:
        lib.addErrorContext "while calling a onDelay function." (
          if property ? onDelay then
            property.onDelay name p
          else
            p
        );
    in
      foldProperty callOnDelay id attrs;

  # Call onGlobalDelay functions.
  triggerPropertiesGlobalDelay = name: attrs:
    let
      globalDelayFuns = uniqListExt {
        getter = property: property._type;
        inputList = foldProperty (p@{property, content, ...}:
          if property ? onGlobalDelay then
            [ property ] ++ content
          else
            content
        ) (a: []) attrs;
      };

      callOnGlobalDelay = property: content:
        lib.addErrorContext "while calling a onGlobalDelay function." (
          property.onGlobalDelay name content
        );
    in
      fold callOnGlobalDelay attrs globalDelayFuns;

  # Expect a list of values which may have properties and return the same
  # list of values where all properties have been evaluated and where all
  # ignored values are removed.  This trigger property handlers called
  # `onEval' and `onGlobalEval'.
  evalProperties = valList:
    if valList != [] then
      filter (x: !isNotdef x) (
        lib.addErrorContext "while evaluating properties an attribute." (
          triggerPropertiesGlobalEval (
            map triggerPropertiesEval valList
      )))
    else
      valList;

  # Call onEval function
  triggerPropertiesEval = val:
    foldProperty (p@{property, ...}:
      lib.addErrorContext "while calling a onEval function." (
        if property ? onEval then
          property.onEval p
        else
          p
      )
    ) id val;

  # Call onGlobalEval function
  triggerPropertiesGlobalEval = valList:
    let
      globalEvalFuns = uniqListExt {
        getter = property: property._type;
        inputList =
          fold (attrs: list:
            foldProperty (p@{property, content, ...}:
              if property ? onGlobalEval then
                [ property ] ++ content
              else
                content
            ) (a: list) attrs
          ) [] valList;
      };

      callOnGlobalEval = property: valList:
        lib.addErrorContext "while calling a onGlobalEval function." (
          property.onGlobalEval valList
        );
    in
      fold callOnGlobalEval valList globalEvalFuns;

  # Remove all properties on top of a value and return the value.
  rmProperties =
    foldProperty (p@{content, ...}: content) id;

  # Copy properties defined on a value on another value.
  copyProperties = attrs: newAttrs:
    foldProperty id (x: newAttrs) attrs;

  /* If. ThenElse. Always. */

  # create "if" statement that can be delayed on sets until a "then-else" or
  # "always" set is reached.  When an always set is reached the condition
  # is ignore.

  # Create a "If" property which only contains a condition.
  isIf = attrs: (typeOf attrs) == "if";
  mkIf = condition: content: mkProperty {
    property = {
      _type = "if";
      onGlobalDelay = onIfGlobalDelay;
      onEval = onIfEval;
      inherit condition;
    };
    inherit content;
  };

  # Create a "ThenElse" property which contains choices being chosen by
  # the evaluation of an "If" statement.
  isThenElse = attrs: (typeOf attrs) == "then-else";
  mkThenElse = attrs:
    assert attrs ? thenPart && attrs ? elsePart;
    mkProperty {
      property = {
        _type = "then-else";
        onEval = val: throw "Missing mkIf statement.";
        inherit (attrs) thenPart elsePart;
      };
      content = mkNotdef;
    };

  # Create an "Always" property removing/ ignoring all "If" statement.
  isAlways = attrs: (typeOf attrs) == "always";
  mkAlways = value:
    mkProperty {
      property = {
        _type = "always";
        onEval = p@{content, ...}: content;
        inherit value;
      };
      content = mkNotdef;
    };

  # Remove all "If" statement defined on a value.
  rmIf = foldProperty (
      foldFilter isIf
        ({content, ...}: content)
        id
    ) id;

  # Evaluate the "If" statements when either "ThenElse" or "Always"
  # statement is encountered.  Otherwise it removes multiple If statements and
  # replaces them by one "If" statement where the condition is the list of all
  # conditions joined with a "and" operation.
  onIfGlobalDelay = name: content:
    let
      # extract if statements and non-if statements and repectively put them
      # in the attribute list and attrs.
      ifProps =
        foldProperty
          (foldFilter (p: isIf p || isThenElse p || isAlways p)
            # then, push the codition inside the list list
            (p@{property, content, ...}:
              { inherit (content) attrs;
                list = [property] ++ content.list;
              }
            )
            # otherwise, add the propertie.
            (p@{property, content, ...}:
              { inherit (content) list;
                attrs = p // { content = content.attrs; };
              }
            )
          )
          (attrs: { list = []; inherit attrs; })
          content;

      # compute the list of if statements.
      evalIf = content: condition: list:
        if list == [] then
          mkIf condition content
        else
          let p = head list; in

          # evaluate the condition.
          if isThenElse p then
            if condition then
              copyProperties content p.thenPart
            else
              copyProperties content p.elsePart
          # ignore the condition.
          else if isAlways p then
            copyProperties content p.value
          # otherwise (isIf)
          else
            evalIf content (condition && p.condition) (tail list);
    in
      evalIf ifProps.attrs true ifProps.list;

  # Evaluate the condition of the "If" statement to either get the value or
  # to ignore the value.
  onIfEval = p@{property, content, ...}:
    if property.condition then
      content
    else
      mkNotdef;

  /* mkOverride */

  # Create an "Override" statement which allow the user to define
  # priorities between values.  The default priority is 100. The lowest
  # priorities are kept.  The template argument must reproduce the same
  # attribute set hierarchy to override leaves of the hierarchy.
  isOverride = attrs: (typeOf attrs) == "override";
  mkOverride = priority: template: content: mkProperty {
    property = {
      _type = "override";
      onDelay = onOverrideDelay;
      onGlobalEval = onOverrideGlobalEval;
      inherit priority template;
    };
    inherit content;
  };

  # Sugar to override the default value of the option by making a new
  # default value based on the configuration.
  mkDefaultValue = content: mkOverride 1000 {} content;

  # Make the template traversal in function of the property traversal.  If
  # the template define a non-empty attribute set, then the property is
  # copied only on all mentionned attributes inside the template.
  # Otherwise, the property is kept on all sub-attribute definitions.
  onOverrideDelay = name: p@{property, content, ...}:
    let inherit (property) template; in
    if isAttrs template && template != {} then
      if hasAttr name template then
        p // {
          property = p.property // {
            template = builtins.getAttr name template;
          };
        }
      # Do not override the attribute \name\
      else
        content
    # Override values defined inside the attribute \name\.
    else
      p;

  # Keep values having lowest priority numbers only throwing away those having
  # a higher priority assigned.
  onOverrideGlobalEval = valList:
    let
      defaultPrio = 100;

      inherit (builtins) lessThan;

      getPrioVal =
        foldProperty
          (foldFilter isOverride
            (p@{property, content, ...}:
              if content ? priority && lessThan content.priority property.priority then
                content
              else
                content // {
                  inherit (property) priority;
                }
            )
            (p@{property, content, ...}:
              content // {
                value = p // { content = content.value; };
              }
            )
          ) (value: { inherit value; });

      addDefaultPrio = x:
        if x ? priority then x
        else x // { priority = defaultPrio; };

      prioValList = map (x: addDefaultPrio (getPrioVal x)) valList;

      higherPrio =
        if prioValList == [] then
          defaultPrio
        else
          fold (x: min:
            if lessThan x.priority min then
              x.priority
            else
              min
          ) (head prioValList).priority (tail prioValList);
    in
      map (x:
        if x.priority == higherPrio then
          x.value
        else
          mkNotdef
      ) prioValList;

}

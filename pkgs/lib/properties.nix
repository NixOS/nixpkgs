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
  delayPropertiesWithIter = iter: path: attrs:
    let cleanAttrs = rmProperties attrs; in
    if isProperty attrs then
      iter (a: v:
        lib.addErrorContext "while moving properties on the attribute `${a}'." (
          triggerPropertiesGlobalDelay a (
            triggerPropertiesDelay a (
              copyProperties attrs v
      )))) path cleanAttrs
    else
      attrs;

  delayProperties = # implicit attrs argument.
    delayPropertiesWithIter (f: p: v: lib.mapAttrs f v) "";

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
        lib.addErrorContext "while evaluating properties." (
          triggerPropertiesGlobalEval (
            evalLocalProperties valList
      )))
    else
      valList;

  evalLocalProperties = valList:
    filter (x: !isNotdef x) (
      lib.addErrorContext "while evaluating local properties." (
        map triggerPropertiesEval valList
    ));

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
  mkOverrideTemplate = priority: template: content: mkProperty {
    property = {
      _type = "override";
      onDelay = onOverrideDelay;
      onGlobalEval = onOverrideGlobalEval;
      inherit priority template;
    };
    inherit content;
  };

  # Currently an alias, but sooner or later the template argument should be
  # removed.
  mkOverride = mkOverrideTemplate;

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

  /* mkOrder */

  # Order definitions based on there index value.  This property is useful
  # when the result of the merge function depends on the order on the
  # initial list.  (e.g. concatStrings) Definitions are ordered based on
  # their rank.  The lowest ranked definition would be the first to element
  # of the list used by the merge function.  And the highest ranked
  # definition would be the last.  Definitions which does not have any rank
  # value have the default rank of 100.
  isOrder = attrs: (typeOf attrs) == "order";
  mkOrder = rank: content: mkProperty {
    property = {
      _type = "order";
      onGlobalEval = onOrderGlobalEval;
      inherit rank;
    };
    inherit content;
  };

  mkHeader = mkOrder 10;
  mkFooter = mkOrder 1000;

  # Fetch the rank of each definition (add the default rank is none) and
  # sort them based on their ranking.
  onOrderGlobalEval = valList:
    let
      defaultRank = 100;

      inherit (builtins) lessThan;

      getRankVal =
        foldProperty
          (foldFilter isOrder
            (p@{property, content, ...}:
              if content ? rank then
                content
              else
                content // {
                  inherit (property) rank;
                }
            )
            (p@{property, content, ...}:
              content // {
                value = p // { content = content.value; };
              }
            )
          ) (value: { inherit value; });

      addDefaultRank = x:
        if x ? rank then x
        else x // { rank = defaultRank; };

      rankValList = map (x: addDefaultRank (getRankVal x)) valList;

      cmp = x: y:
        builtins.lessThan x.rank y.rank;
    in
      map (x: x.value) (sort cmp rankValList);

  /* mkFixStrictness */

  # This is a hack used to restore laziness on some option definitions.
  # Some option definitions are evaluated when they are not used.  This
  # error is caused by the strictness of type checking builtins.  Builtins
  # like 'isAttrs' are too strict because they have to evaluate their
  # arguments to check if the type is correct.  This evaluation, cause the
  # strictness of properties.
  #
  # Properties can be stacked on top of each other.  The stackability of
  # properties on top of the option definition is nice for user manipulation
  # but require to check if the content of the property is not another
  # property.  Such testing implies to verify if this is an attribute set
  # and if it possess the type 'property'. (see isProperty & typeOf)
  #
  # To avoid strict evaluation of option definitions, 'mkFixStrictness' is
  # introduced.  This property protects an option definition by replacing
  # the base of the stack of properties by 'mkNotDef', when this property is
  # evaluated it returns the original definition.
  #
  # This property is useful over any elements which depends on options which
  # are raising errors when they get evaluated without the proper settings.
  #
  # Plain list and attribute set are lazy structures, which means that the
  # container gets evaluated but not the content.  Thus, using this property
  # on top of plain list or attribute set is pointless.
  #
  # This is a Hack, you should avoid it!

  # This property has a long name because you should avoid it.
  isFixStrictness = attrs: (typeOf attrs) == "fix-strictness";
  mkFixStrictness = value:
    mkProperty {
      property = {
        _type = "fix-strictness";
        onEval = p: value;
      };
      content = mkNotdef;
    };

}

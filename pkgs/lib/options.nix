# Nixpkgs/NixOS option handling.

let lib = import ./default.nix; in

with { inherit (builtins) head tail; };
with import ./trivial.nix;
with import ./lists.nix;
with import ./misc.nix;
with import ./attrsets.nix;

rec {


  mkOption = attrs: attrs // {_type = "option";};

  hasType = x: isAttrs x && x ? _type;
  typeOf = x: if hasType x then x._type else "";

  isOption = attrs: (typeOf attrs) == "option";

  addDefaultOptionValues = defs: opts: opts //
    builtins.listToAttrs (map (defName:
      { name = defName;
        value = 
          let
            defValue = builtins.getAttr defName defs;
            optValue = builtins.getAttr defName opts;
          in
          if typeOf defValue == "option"
          then
            # `defValue' is an option.
            if hasAttr defName opts
            then builtins.getAttr defName opts
            else defValue.default
          else
            # `defValue' is an attribute set containing options.
            # So recurse.
            if hasAttr defName opts && isAttrs optValue 
            then addDefaultOptionValues defValue optValue
            else addDefaultOptionValues defValue {};
      }
    ) (attrNames defs));

  mergeDefaultOption = list:
    if list != [] && tail list == [] then head list
    else if all builtins.isFunction list then x: mergeDefaultOption (map (f: f x) list)
    else if all isList list then concatLists list
    else if all isAttrs list then fold lib.mergeAttrs {} list
    else if all (x: true == x || false == x) list then fold lib.or false list
    else if all (x: x == toString x) list then lib.concatStrings list
    else throw "Cannot merge values.";

  mergeTypedOption = typeName: predicate: merge: list:
    if all predicate list then merge list
    else throw "Expect a ${typeName}.";

  mergeEnableOption = mergeTypedOption "boolean"
    (x: true == x || false == x) (fold lib.or false);

  mergeListOption = mergeTypedOption "list" isList concatLists;

  mergeStringOption = mergeTypedOption "string"
    (x: if builtins ? isString then builtins.isString x else x + "")
    lib.concatStrings;

  mergeOneOption = list:
    if list == [] then abort "This case should never happen."
    else if tail list != [] then throw "Multiple definitions. Only one is allowed for this option."
    else head list;


  # Handle the traversal of option sets.  All sets inside 'opts' are zipped
  # and options declaration and definition are separated.  If no option are
  # declared at a specific depth, then the function recurse into the values.
  # Other cases are handled by the optionHandler which contains two
  # functions that are used to defined your goal.
  # - export is a function which takes two arguments which are the option
  # and the list of values.
  # - notHandle is a function which takes the list of values are not handle
  # by this function.
  handleOptionSets = optionHandler@{export, notHandle, ...}: path: opts:
    if all isAttrs opts then
      lib.zip (attr: opts:
        let
          # Compute the path to reach the attribute.
          name = if path == "" then attr else path + "." + attr;

          # Divide the definitions of the attribute "attr" between
          # declaration (isOption) and definitions (!isOption).
          test = partition isOption opts;
          decls = test.right; defs = test.wrong;

          # Return the option declaration and add missing default
          # attributes.
          opt = {
            inherit name;
            merge = mergeDefaultOption;
            apply = lib.id;
          } // (head decls);

          # Return the list of option sets.
          optAttrs = map delayProperties defs;

          # return the list of option values.
          # Remove undefined values that are coming from evalIf.
          optValues = evalProperties defs;
        in
          if decls == [] then handleOptionSets optionHandler name optAttrs
          else lib.addErrorContext "while evaluating the option ${name}:" (
            if tail decls != [] then throw "Multiple options."
            else export opt optValues
          )
      ) opts
   else lib.addErrorContext "while evaluating ${path}:" (notHandle opts);

  # Merge option sets and produce a set of values which is the merging of
  # all options declare and defined.  If no values are defined for an
  # option, then the default value is used otherwise it use the merge
  # function of each option to get the result.
  mergeOptionSets =
    handleOptionSets {
      export = opt: values:
        opt.apply (
          if values == [] then
            if opt ? default then opt.default
            else throw "Not defined."
          else opt.merge values
        );
      notHandle = opts: throw "Used without option declaration.";
    };

  # Keep all option declarations.
  filterOptionSets =
    handleOptionSets {
      export = opt: values: opt;
      notHandle = opts: {};
    };


  # Unfortunately this can also be a string.
  isPath = x: !(
     builtins.isFunction x
  || builtins.isAttrs x
  || builtins.isInt x
  || builtins.isBool x
  || builtins.isList x
  );


  # Evaluate a list of option sets that would be merged with the
  # function "merge" which expects two arguments.  The attribute named
  # "require" is used to imports option declarations and bindings.
  #
  # * cfg[0-9]: configuration
  # * cfgSet[0-9]: configuration set
  #
  # merge: the function used to merge options sets.
  # pkgs: is the set of packages available. (nixpkgs)
  # opts: list of option sets or option set functions.
  # config: result of this evaluation.
  fixOptionSetsFun = merge: pkgs: opts: config:
    let
      # remove possible mkIf to access the require attribute.
      noImportConditions = cfgSet0:
        let cfgSet1 = delayProperties cfgSet0; in
        if cfgSet1 ? require then
          cfgSet1 // { require = rmProperties cfgSet1.require; }
        else
          cfgSet1;

      filenameHandler = cfg:
        if isPath cfg then import cfg
        else cfg;

      # call configuration "files" with one of the existing convention.
      argumentHandler = cfg:
        let
          # {..}
          cfg0 = cfg;
          # {pkgs, config, ...}: {..}
          cfg1 = cfg { inherit pkgs config merge; };
          # pkgs: config: {..}
          cfg2 = cfg {} {};
        in
        if builtins.isFunction cfg0 then
          if isAttrs cfg1 then cfg1
          else builtins.trace "Use '{pkgs, config, ...}:'." cfg2
        else cfg0;

      preprocess = cfg0:
        let cfg1 = filenameHandler cfg0;
            cfg2 = argumentHandler cfg1;
            cfg3 = noImportConditions cfg2;
        in cfg3;

      getRequire = x: toList (attrByPath ["require"] [] (preprocess x));
      getRecursiveRequire = x:
        fold (cfg: l:
          if isPath cfg then
            [ cfg ] ++ l
          else
            [ cfg ] ++ (getRecursiveRequire cfg) ++ l
        ) [] (getRequire x);

      getRequireSets = x: filter (x: ! isPath x) (getRecursiveRequire x);
      getRequirePaths = x: filter isPath (getRecursiveRequire x);
      rmRequire = x: removeAttrs (preprocess x) ["require"];

      inlineRequiredSets = cfgs:
        fold (cfg: l: [ cfg ] ++ (getRequireSets cfg) ++ l) [] cfgs;
    in
      merge "" (
        map rmRequire (
          inlineRequiredSets ((toList opts) ++ lib.uniqFlatten getRequirePaths [] [] (lib.concatMap getRequirePaths (toList opts)))
        )
      );

  fixOptionSets = merge: pkgs: opts:
    lib.fix (fixOptionSetsFun merge pkgs opts);

  optionAttrSetToDocList = l: attrs:
    if (attrByPath ["_type"] "" attrs) == "option" then
      [({
	#inherit (attrs) description;
        description = if attrs ? description then attrs.description else 
          throw ("No description ${toString l} : ${lib.whatis attrs}");
      }
      // (if attrs ? example then {inherit(attrs) example;} else {} )
      // (if attrs ? default then {inherit(attrs) default;} else {} )
      // {name = l;}
      )]
      else (concatLists (map (s: (optionAttrSetToDocList 
        (l + (if l=="" then "" else ".") + s) (builtins.getAttr s attrs)))
        (attrNames attrs)));

  /* Option Properties */
  # Generalize the problem of delayable properties.  Any property can be created


  # Tell that nothing is defined.  When properties are evaluated, this type
  # is used to remove an entry.  Thus if your property evaluation semantic
  # implies that you have to mute the content of an attribute, then your
  # property should produce this value.
  isNotdef = attrs: (typeOf attrs) == "notdef";
  mkNotdef = {_type = "notdef";};

  # General property type, it has a property attribute and a content
  # attribute.  The property attribute refer to an attribute set which
  # contains a _type attribute and a list of functions which are used to
  # evaluate this property.  The content attribute is used to stack property
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

  # Go throw the stack of properties and apply the function `op' on all
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
    if cleanAttrs != attrs then
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

  # Create a "ThenElse" property which contains choices which can choosed by
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

  # Create an "Always" property remove ignore all "If" statement.
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
  # statement is encounter.  Otherwise it remove multiple If statement and
  # replace them by one "If" staement where the condition is the list of all
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
  # prioprities between values.  The default priority is 100 and the lowest
  # priorities are kept.  The template argument must reproduce the same
  # attribute set hierachy to override leaves of the hierarchy.
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

  # Ignore all values which have a higher value of the priority number.
  onOverrideGlobalEval = valList:
    let
      defaultPrio = 100;

      inherit (builtins) lessThan;

      getPrioVal =
        foldProperty
          (foldFilter isOverride
            (p@{property, content, ...}:
              if lessThan content.priority property.priority then
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
          ) (value: { priority = defaultPrio; inherit value; });

      prioValList = map getPrioVal valList;

      higherPrio = fold (x: y:
        if lessThan x.priority y then
          x.priority
        else
          y
      ) defaultPrio prioValList;
    in
      map (x:
        if x.priority == higherPrio then
          x.value
        else
          mkNotdef
      ) prioValList;

}

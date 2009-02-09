# Nixpkgs/NixOS option handling.

let lib = import ./default.nix; in

with { inherit (builtins) head tail; };
with import ./lists.nix;
with import ./attrsets.nix;

rec {


  mkOption = attrs: attrs // {_type = "option";};

  typeOf = x: if (__isAttrs x && x ? _type) then x._type else "";

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
            if builtins.hasAttr defName opts
            then builtins.getAttr defName opts
            else defValue.default
          else
            # `defValue' is an attribute set containing options.
            # So recurse.
            if builtins.hasAttr defName opts && builtins.isAttrs optValue 
            then addDefaultOptionValues defValue optValue
            else addDefaultOptionValues defValue {};
      }
    ) (builtins.attrNames defs));

  mergeDefaultOption = list:
    if list != [] && tail list == [] then head list
    else if all __isFunction list then x: mergeDefaultOption (map (f: f x) list)
    else if all __isList list then concatLists list
    else if all __isAttrs list then fold lib.mergeAttrs {} list
    else if all (x: true == x || false == x) list then fold lib.or false list
    else if all (x: x == toString x) list then lib.concatStrings list
    else throw "Cannot merge values.";

  mergeTypedOption = typeName: predicate: merge: list:
    if all predicate list then merge list
    else throw "Expect a ${typeName}.";

  mergeEnableOption = mergeTypedOption "boolean"
    (x: true == x || false == x) (fold lib.or false);

  mergeListOption = mergeTypedOption "list"
    __isList concatLists;

  mergeStringOption = mergeTypedOption "string"
    (x: if builtins ? isString then builtins.isString x else x + "")
    lib.concatStrings;

  mergeOneOption = list:
    if list == [] then abort "This case should never happens."
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
    if all __isAttrs opts then
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
          optAttrs = map delayIf defs;

          # return the list of option values.
          # Remove undefined values that are coming from evalIf.
          optValues = filter (x: !isNotdef x) (map evalIf defs);
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
  mergeOptionSets = noOption: newMergeOptionSets; # ignore argument
  newMergeOptionSets =
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
        let cfgSet1 = delayIf cfgSet0; in
        if cfgSet1 ? require then
          cfgSet1 // { require = rmIf cfgSet1.require; }
        else
          cfgSet1;

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
        if __isFunction cfg0 then
          if builtins.isAttrs cfg1 then cfg1
          else builtins.trace "Use '{pkgs, config, ...}:'." cfg2
        else cfg0;

      preprocess = cfg0:
        let cfg1 = argumentHandler cfg0;
            cfg2 = noImportConditions cfg1;
        in cfg2;

      getRequire = x: toList (getAttr ["require"] [] (preprocess x));
      rmRequire = x: removeAttrs (preprocess x) ["require"];
    in
      merge "" (
        map rmRequire (
          lib.uniqFlatten getRequire [] [] (toList opts)
        )
      );

  fixOptionSets = merge: pkgs: opts:
    lib.fix (fixOptionSetsFun merge pkgs opts);

  optionAttrSetToDocList = l: attrs:
    if (getAttr ["_type"] "" attrs) == "option" then
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
        (builtins.attrNames attrs)));

        
  /* If. ThenElse. Always. */
  # !!! cleanup needed

  # create "if" statement that can be dealyed on sets until a "then-else" or
  # "always" set is reached.  When an always set is reached the condition
  # is ignore.

  isIf = attrs: (typeOf attrs) == "if";
  mkIf = condition: thenelse:
    if isIf thenelse then
      mkIf (condition && thenelse.condition) thenelse.thenelse
    else {
      _type = "if";
      inherit condition thenelse;
    };


  isNotdef = attrs: (typeOf attrs) == "notdef";
  mkNotdef = {_type = "notdef";};


  isThenElse = attrs: (typeOf attrs) == "then-else";
  mkThenElse = attrs:
    assert attrs ? thenPart && attrs ? elsePart;
    attrs // { _type = "then-else"; };


  isAlways = attrs: (typeOf attrs) == "always";
  mkAlways = value: { inherit value; _type = "always"; };

  pushIf = f: attrs:
    if isIf attrs then pushIf f (
      let val = attrs.thenelse; in
      # evaluate the condition.
      if isThenElse val then
        if attrs.condition then
          val.thenPart
        else
          val.elsePart
      # ignore the condition.
      else if isAlways val then
        val.value
      # otherwise
      else
        f attrs.condition val)
    else
      attrs;

  # take care otherwise you will have to handle this by hand.
  rmIf = pushIf (condition: val: val);

  evalIf = pushIf (condition: val:
    if condition then val else mkNotdef
  );

  delayIf = pushIf (condition: val:
    # rewrite the condition on sub-attributes.
    lib.mapAttrs (name: mkIf condition) val
  );

}
# Given a configuration, this function returns an object with a `get'
# method for retrieving the values of options, falling back to the
# defaults declared in options.nix if no value is given for an
# option.

pkgs: config:

let

  lib = pkgs.library;

  # The option declarations, i.e., option names with defaults and
  # documentation.
  declarations = import ./options.nix {inherit pkgs; inherit (lib) mkOption;};

  configFilled = lib.addDefaultOptionValues declarations config;

  # Get the option named `name' from the user configuration, using
  # its default value if it's not defined.
  get = name:
    /*
    let
      decl =
        lib.findSingle (decl: lib.eqLists decl.name name)
          (abort ("Undeclared option `" + printName name + "'."))
          (abort ("Multiple declarations for option `" + printName name + "'."))
          declarations;
      default =
        if !decl ? default
        then abort ("Option `" + printName name + "' has no default.")
        else decl.default;
    in lib.getAttr name default config;
    */
    let
      default = abort ("Undeclared option `" + printName name + "'.");
    in lib.getAttr name default configFilled;
  
  printName = name: lib.concatStrings (lib.intersperse "." name);

in configFilled // {inherit get;}

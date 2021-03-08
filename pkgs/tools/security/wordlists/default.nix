{ lib
, pkgs
, runtimeShell
, symlinkJoin
, tree
}:

let
  _wordlistData =
    [ { name = "dirbuster"; expressionPath = ./dirbuster.nix; }
      { name = "nmap"; expressionPath = ./nmap.nix; needsPackage = true; }
      { name = "rockyou"; expressionPath = ./rockyou.nix; }
      { name = "seclists"; expressionPath = ./seclists.nix; }
      { name = "wfuzz"; expressionPath = ./wfuzz.nix; needsPackage = true; }
    ];

  scopedWordlists = lib.makeScope pkgs.newScope (self: with self;
    let _packageWithLinkCommandFrom = acc: datum:
      # Some wordlists are based on an already existing `nixpkgs` package; Pass it as parameter of the expression.
      let parameters = {}
        // lib.optionalAttrs ((builtins.elem "needsPackage" (builtins.attrNames datum)) && datum.needsPackage) { ${datum.name} = pkgs.${datum.name}; };
      in
        let p = callPackage datum.expressionPath parameters;
        in acc // { ${datum.name} = p; };
    in builtins.foldl' _packageWithLinkCommandFrom {} _wordlistData
  );

in let
  packageConstructor = wordlistPackages:
    symlinkJoin rec {
      pname = "security-wordlists";
      version = "unstable-2020-11-23";

      name = "${pname}-${version}";

      paths = wordlistPackages;

      dontUnpack = true;

      propagatedBuildInputs = [ tree ];

      postBuild = ''
        # Create a command to show the location of the links.
        mkdir -p $out/bin
        cat >> $out/bin/wordlists << __EOF__
          #!${runtimeShell}
          ${tree}/bin/tree $out/share
        __EOF__
        chmod +x $out/bin/wordlists

        # Create a handy command for easy access to the wordlists.
        # e.g.: `cat "$(wordlists_path)/rockyou.txt"`, or `ls "$(wordlists_path)/dirbuster"`
        cat >> $out/bin/wordlists_path << __EOF__
          #!${runtimeShell}
          echo $out/share
        __EOF__
        chmod +x $out/bin/wordlists_path
      '';

      meta = with lib; {
        description = "A collection of wordlists useful for security testing";
        maintainers = with maintainers; [ pamplemousse ];
      };
    };
in {
  pkgs = scopedWordlists;
  withLists = f: packageConstructor (f scopedWordlists);
}

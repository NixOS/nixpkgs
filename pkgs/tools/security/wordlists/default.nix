{ lib
, pkgs
, runtimeShell
, stdenv
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
  # Given an array of wordlist packages,
  # return an array of bash commands to create symlinks to the files shared by each package.
  allLinksCommandFor = wordlistPackages:
    lib.concatStringsSep "\n" (builtins.map (x: "ln -s ${x}/share/${x.passthru.shared} $out/share/${x.passthru.shared}") wordlistPackages);

in let
  packageConstructor = wordlistPackages:
    stdenv.mkDerivation rec {
      pname = "security-wordlists";
      version = "unstable-2020-11-23";

      dontUnpack = true;

      propagatedBuildInputs = [ tree ];

      installPhase = ''
        # Create the links to the requested wordlists.
        mkdir -p $out/share

        ${allLinksCommandFor wordlistPackages}

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

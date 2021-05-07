{ callPackage
, lib
, pkgs
, runtimeShell
, symlinkJoin
, tree
, wfuzz
}:

let
  scopedWordlists = lib.makeScope pkgs.newScope (_:
    {
      dirbuster = callPackage ./dirbuster.nix { };
      nmap = callPackage ./nmap.nix { };
      rockyou = callPackage ./rockyou.nix { };
      seclists = callPackage ./seclists.nix { };
      wfuzz = wfuzz.wordlists;
    }
  );
in
{
  pkgs = scopedWordlists;
  withLists = f: symlinkJoin rec {
    pname = "security-wordlists";
    version = "unstable-2020-11-23";

    name = "${pname}-${version}";
    paths = f scopedWordlists;

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
}

args: with args; with lib;
let 
  repoDir = builtins.getEnv "HOME" + "/managed_repos";
  toConfigLine = name : set : 
    "[(\"name\",\"${name}\")," + ( concatStringsSep "," (map (a: "(\"${a}\",\"${__getAttr a set}\")" ) (__attrNames set)))+"]";
  config = writeText "nix_repository_manager_config"
        (repoDir+"\n" +
        concatStringsSep "\n" (mapRecordFlatten toConfigLine bleeding_edge_repos));

in
args.stdenv.mkDerivation {

  inherit repoDir; # amend repoDir so that you know which one to take when installing bleeding edge packages 

  name = "nix_repository_manager";

  #src = args.fetchdarcs {
  #  url = http://mawercer.de/~marc/repos/nix_repository_manager;
  #  md5 = "b33ba7a5b756eda00a79ba34505ea7ee";
  #};
  source = /pr/haskell/nix_repository_manager/nix_repository_manager.hs;

  phases = "buildPhase";

  buildPhase = "
    s=\$out/share/nix_repository_manager
    ensureDir \$out/bin \$s
    #ghc --make nix_repository_manager.hs -o \$s/nix_repository_manager
    ghc --make \$source -o \$s/nix_repository_manager
    b=\$out/bin/nix_repository_manager
    echo -e \"#!/bin/sh\\n\$s/nix_repository_manager --config ${config} \\\$@\" > \$b
    chmod +x \$b
  ";

  buildInputs = [ghc];

  meta = { 
      description = "makes it easy to keep some packages up to date";
      homepage = http://mawercer.de/repos/nix_repository_manager;
      license = "do with it what you want";
  };
}

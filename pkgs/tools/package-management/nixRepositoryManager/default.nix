/*
   repos for config file taken from all-pacakges.bleedingEdgeFetchInfo

    nix-repository-manager --update <name> (for your local use only)

  if you want to publish repos ask for the password (marco-oweber@gmx.de)
      echo '{ bleedingEdgeFetchInfo = "${your_nix_pkgs_location}/pkgs/misc/bleeding-edge-fetch-info"; }' >> .nixpkgs/config.nix  
    reinstall nix-repository-manager to recreate config
      nix-repository-manager --publish <name> (to save on server
*/


args: with args; with lib;
let 
  toConfigLine = name : set : 
    "[(\"name\",\"${name}\")," + ( concatStringsSep "," (map (a: "(\"${a}\",\"${__getAttr a set}\")" ) (__attrNames set)))+"]";
  nixPublishDir = getConfig [ "bleedingEdgeRepos" "bleedingEdgeFetchInfo"] "/tmp/bleeding-edge-fetch-info";
  config = writeText "nix-repository-manager_config"
        (bleedingEdgeRepos.managedRepoDir+"\n" +
         nixPublishDir+"\n" +
        concatStringsSep "\n" (mapRecordFlatten toConfigLine (bleedingEdgeRepos.repos)));

in
args.stdenv.mkDerivation {

  name = "nix-repository-manager";

  src = bleedingEdgeRepos.sourceByName "nix_repository_manager";

  phases = "unpackPhase buildPhase";

  buildPhase = "
    s=\$out/share/nix-repository-manager
    ensureDir \$out/bin \$s
    #ghc --make nix-repository-manager.hs -o \$s/nix-repository-manager
    ghc --make nix-repository-manager.hs -o \$s/nix-repository-manager
    b=\$out/bin/nix-repository-manager
    echo -e \"#!/bin/sh\\n\$s/nix-repository-manager --config ${config} \\\$@\" > \$b
    chmod +x \$b
  ";

  buildInputs = [ghc];

  meta = { 
      description = "makes it easy to keep some packages up to date";
      homepage = http://mawercer.de/repos/nix-repository-manager;
      license = "GPL";
  };
}

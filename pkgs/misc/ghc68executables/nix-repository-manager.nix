/*
   repos for config file taken from all-pacakges.bleedingEdgeFetchInfo

    nix-repository-manager --update <name> (for your local use only)

  if you want to publish repos ask for the password (marco-oweber@gmx.de)
      echo '{ bleedingEdgeFetchInfo = "${your_nix_pkgs_location}/pkgs/misc/bleeding-edge-fetch-info"; }' >> .nixpkgs/config.nix  
    reinstall nix-repository-manager to recreate config
      nix-repository-manager --publish <name> (to save on server
*/


args: with args; with args.lib;
let 
  toConfigLine = name : set : 
    "[(\"name\",\"${name}\")," + ( concatStringsSep "," (map (a: "(\"${a}\",\"${__getAttr a set}\")" ) (__attrNames set)))+"]";
  config = pkgs.writeText "nix-repository-manager_config"
        (bleedingEdgeRepos.managedRepoDir+"\n" +
        concatStringsSep "\n" (mapRecordFlatten toConfigLine (bleedingEdgeRepos.repos)));

in

{
  name = "nix-repository-manager";

  libsFun = x : [x.base x.time x.old_locale x.mtl];

  src = bleedingEdgeRepos.sourceByName "nix_repository_manager";

  pass = {
    buildPhase = ''
    cp ${pkgs.getConfig ["nixRepositoryManager" "sourcefile"] "nix-repository-manager.hs"} source.hs
    s=$out/share/nix-repository-manager
    ensureDir $out/bin $s
    ghc --make source.hs -o $s/nix-repository-manager
    b=$out/bin/nix-repository-manager
    echo -e "#!/bin/sh\n$s/nix-repository-manager ${config} \$@" > $b
    chmod +x $b
    '';
  };

  meta = { 
      description = "makes it easy to keep some packages up to date";
      homepage = http://mawercer.de/repos/nix-repository-manager;
      license = "GPL";
  };
}

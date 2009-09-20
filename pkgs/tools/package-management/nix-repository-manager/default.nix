{lib, bleedingEdgeRepos, writeText, ghcReal, getConfig, stdenv, writeScriptBin }:

/* usage
   see pkgs/development/misc/bleeding-edge-repos/default.nix [1]
   and pkgs/misc/bleeding-edge-fetch-infos.nix

   Either add repository definitions which can be used by sourceByName "foo"
   to [1] or config.nix. Example:

   bleedingEdgeRepos = {
     useLocalRepos = true; # prefer local dist file if availible

     repos = {
        # the attr names are equal to the repo IDs [2]
        getOptions = { type="darcs"; url="http://repetae.net/john/repos/GetOptions"; };
        nobug = { type = "git"; url="git://git.pipapo.org/nobug"; };
        anyterm = { type = "svn"; url="http://svn.anyterm.org/anyterm/tags/releases/1.1/1.1.25/"; };
        gnash = { type = "cvs"; cvsRoot=":pserver:anonymous@cvs.sv.gnu.org:/sources/gnash"; module="gnash"; };
        octave = { type = "hg"; url="http://www.octave.org/hg/octave"; groups="octave_group"; };
     };
   };


   to fetch / update the repository given by ID [2] use:
   $ run-nix-repository-manager-with-config [$PATH_TO_NIXPKGS] --update ID
   This will also calculate the current hash of the dist file which will be
   saved to $PATH_TO_NIXPKGS/pkgs/misc/bleeding-edge-fetch-infos.nix.

   Distribute the dist file which is stored in ~/managed_repos/dist using
   $ run-nix-repository-manager-with-config --publish ID
   this will upload the file to my server. Contact MarcWeber to get login data.
   It should be easy to add multiple mirror locations instead (?)

   You can add groups="xorg"; as seen above to update / distribute all
   packages belonging to that group.
*/

let
  inherit (builtins) getAttr attrNames;
  inherit (lib) concatStringsSep mapAttrsFlatten;
  toConfigLine = name : set : 
    "[(\"name\",\"${name}\")," + ( concatStringsSep "," (map (a: "(\"${a}\",\"${getAttr a set}\")" ) (attrNames set)))+"]";
  config = writeText "nix-repository-manager_config"
        (bleedingEdgeRepos.managedRepoDir+"\n" +
        concatStringsSep "\n" (mapAttrsFlatten toConfigLine (bleedingEdgeRepos.repos)));

  cfg = getConfig ["nixRepositoryManager" ] {};

  provideSource = if (builtins.hasAttr "sourcefile" cfg) then
     "cp ${cfg.sourcefile} source.hs "
    else ''
      src="${bleedingEdgeRepos.sourceByName "nix_repository_manager"}"
      unpackPhase
      mv nix_repsoitory_manager_tmp_dir/nix-repository-manager.hs source.hs
    '';

  nixRepositoryManager = stdenv.mkDerivation {
    name = "nix-repository-manager";

    phases="buildPhase";
    buildPhase = ''
      ${provideSource}
      ensureDir $out/bin
      ghc --make source.hs -o $out/bin/nix-repository-manager
    '';

    buildInputs = [ ghcReal ];

    meta = { 
        description = "makes it easy to keep some packages up to date";
        license = "GPL";
    };
  };
in writeScriptBin "run-nix-repository-manager-with-config" 
''
#!/bin/sh
exec ${nixRepositoryManager}/bin/nix-repository-manager ${config} $@
''

{ lib, pkgs }:
let
  inherit (import ./semver.nix { inherit lib ireplace; }) satisfiesSemver;
  inherit (builtins) genList length;

  # Replace a list entry at defined index with set value
  ireplace = idx: value: list: (
    genList (i: if i == idx then value else (builtins.elemAt list i)) (length list)
  );

  # Returns true if pythonVersion matches with the expression in pythonVersions
  isCompatible = pythonVersion: pythonVersions:
    let
      operators = {
        "||" = cond1: cond2: cond1 || cond2;
        "," = cond1: cond2: cond1 && cond2; # , means &&
      };
      # split string at "," and "||"
      tokens = builtins.filter (x: x != "") (builtins.split "(,|\\|\\|)" pythonVersions);
      combine = acc: v:
        let
          isOperator = builtins.typeOf v == "list";
          operator = if isOperator then (builtins.elemAt v 0) else acc.operator;
        in
          if isOperator then (acc // { inherit operator; }) else {
            inherit operator;
            state = operators."${operator}" acc.state (satisfiesSemver pythonVersion v);
          };
      initial = { operator = ","; state = true; };
    in
      (builtins.foldl' combine initial tokens).state;

  fromTOML = builtins.fromTOML or
    (
      toml: builtins.fromJSON (
        builtins.readFile (
          pkgs.runCommand "from-toml"
            {
              inherit toml;
              allowSubstitutes = false;
              preferLocalBuild = true;
            }
            ''
              ${pkgs.remarshal}/bin/remarshal \
                -if toml \
                -i <(echo "$toml") \
                -of json \
                -o $out
            ''
        )
      )
    );
  readTOML = path: fromTOML (builtins.readFile path);

  #
  # Returns the appropriate manylinux dependencies and string representation for the file specified
  #
  getManyLinuxDeps = f:
    let
      ml = pkgs.pythonManylinuxPackages;
    in
      if lib.strings.hasInfix "manylinux1" f then { pkg = [ ml.manylinux1 ]; str = "1"; }
      else if lib.strings.hasInfix "manylinux2010" f then { pkg = [ ml.manylinux2010 ]; str = "2010"; }
      else if lib.strings.hasInfix "manylinux2014" f then { pkg = [ ml.manylinux2014 ]; str = "2014"; }
      else { pkg = []; str = null; };

  # Fetch the artifacts from the PyPI index. Since we get all
  # info we need from the lock file we don't use nixpkgs' fetchPyPi
  # as it modifies casing while not providing anything we don't already
  # have.
  #
  # Args:
  #   pname: package name
  #   file: filename including extension
  #   hash: SRI hash
  #   kind: Language implementation and version tag https://www.python.org/dev/peps/pep-0427/#file-name-convention
  fetchFromPypi = lib.makeOverridable (
    { pname, file, hash, kind }:
      pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/${kind}/${lib.toLower (builtins.substring 0 1 file)}/${pname}/${file}";
        inherit hash;
      }
  );

  getBuildSystemPkgs =
    { pythonPackages
    , pyProject
    }: let
      buildSystem = lib.getAttrFromPath [ "build-system" "build-backend" ] pyProject;
      drvAttr = builtins.elemAt (builtins.split "\\.|:" buildSystem) 0;
    in
      if buildSystem == "" then [] else (
        [ pythonPackages.${drvAttr} or (throw "unsupported build system ${buildSystem}") ]
      );

in
{
  inherit
    fetchFromPypi
    getManyLinuxDeps
    isCompatible
    readTOML
    getBuildSystemPkgs
    ;
}

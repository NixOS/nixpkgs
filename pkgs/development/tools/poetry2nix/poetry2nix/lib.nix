{ lib, pkgs, stdenv }:
let
  inherit (import ./semver.nix { inherit lib ireplace; }) satisfiesSemver;
  inherit (builtins) genList length;

  # Replace a list entry at defined index with set value
  ireplace = idx: value: list: (
    genList (i: if i == idx then value else (builtins.elemAt list i)) (length list)
  );

  # Normalize package names as per PEP 503
  normalizePackageName = name:
    let
      parts = builtins.split "[-_.]+" name;
      partsWithoutSeparator = builtins.filter (x: builtins.typeOf x == "string") parts;
    in
    lib.strings.toLower (lib.strings.concatStringsSep "-" partsWithoutSeparator);

  # Normalize an entire attrset of packages
  normalizePackageSet = lib.attrsets.mapAttrs' (name: value: lib.attrsets.nameValuePair (normalizePackageName name) value);

  # Get a full semver pythonVersion from a python derivation
  getPythonVersion = python:
    let
      pyVer = lib.splitVersion python.pythonVersion ++ [ "0" ];
      ver = lib.splitVersion python.version;
      major = l: lib.elemAt l 0;
      minor = l: lib.elemAt l 1;
      joinVersion = v: lib.concatStringsSep "." v;
    in
    joinVersion (if major pyVer == major ver && minor pyVer == minor ver then ver else pyVer);

  # Compare a semver expression with a version
  isCompatible = version:
    let
      operators = {
        "||" = cond1: cond2: cond1 || cond2;
        "," = cond1: cond2: cond1 && cond2; # , means &&
        "&&" = cond1: cond2: cond1 && cond2;
      };
      splitRe = "(" + (builtins.concatStringsSep "|" (builtins.map (x: lib.replaceStrings [ "|" ] [ "\\|" ] x) (lib.attrNames operators))) + ")";
    in
    expr:
    let
      tokens = builtins.filter (x: x != "") (builtins.split splitRe expr);
      combine = acc: v:
        let
          isOperator = builtins.typeOf v == "list";
          operator = if isOperator then (builtins.elemAt v 0) else acc.operator;
        in
        if isOperator then (acc // { inherit operator; }) else {
          inherit operator;
          state = operators."${operator}" acc.state (satisfiesSemver version v);
        };
      initial = { operator = "&&"; state = true; };
    in
    if expr == "" then true else (builtins.foldl' combine initial tokens).state;
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
    else if lib.strings.hasInfix "manylinux_" f then { pkg = [ ml.manylinux2014 ]; str = "pep600"; }
    else { pkg = [ ]; str = null; };

  # Predict URL from the PyPI index.
  # Args:
  #   pname: package name
  #   file: filename including extension
  #   hash: SRI hash
  #   kind: Language implementation and version tag
  predictURLFromPypi = lib.makeOverridable (
    { pname, file, hash, kind }:
    "https://files.pythonhosted.org/packages/${kind}/${lib.toLower (builtins.substring 0 1 file)}/${pname}/${file}"
  );


  # Fetch from the PyPI index.
  # At first we try to fetch the predicated URL but if that fails we
  # will use the Pypi API to determine the correct URL.
  # Args:
  #   pname: package name
  #   file: filename including extension
  #   version: the version string of the dependency
  #   hash: SRI hash
  #   kind: Language implementation and version tag
  fetchFromPypi = lib.makeOverridable (
    { pname, file, version, hash, kind, curlOpts ? "" }:
    let
      predictedURL = predictURLFromPypi { inherit pname file hash kind; };
    in
    (pkgs.stdenvNoCC.mkDerivation {
      name = file;
      nativeBuildInputs = [
        pkgs.buildPackages.curl
        pkgs.buildPackages.jq
      ];
      isWheel = lib.strings.hasSuffix "whl" file;
      system = "builtin";

      preferLocalBuild = true;
      impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
        "NIX_CURL_FLAGS"
      ];

      inherit pname file version curlOpts predictedURL;

      builder = ./fetch-from-pypi.sh;

      outputHashMode = "flat";
      outputHashAlgo = "sha256";
      outputHash = hash;

      passthru = {
        urls = [ predictedURL ]; # retain compatibility with nixpkgs' fetchurl
      };
    })
  );

  fetchFromLegacy = lib.makeOverridable (
    { python, pname, url, file, hash }:
    let
      pathParts =
        (builtins.filter
          ({ prefix, path }: "NETRC" == prefix)
          builtins.nixPath);
      netrc_file = if (pathParts != [ ]) then (builtins.head pathParts).path else "";
    in
    pkgs.runCommand file
      {
        nativeBuildInputs = [ python ];
        impureEnvVars = lib.fetchers.proxyImpureEnvVars;
        outputHashMode = "flat";
        outputHashAlgo = "sha256";
        outputHash = hash;
        NETRC = netrc_file;
      } ''
      python ${./fetch_from_legacy.py} ${url} ${pname} ${file}
      mv ${file} $out
    ''
  );

  getBuildSystemPkgs =
    { pythonPackages
    , pyProject
    }:
    let
      missingBuildBackendError = "No build-system.build-backend section in pyproject.toml. "
        + "Add such a section as described in https://python-poetry.org/docs/pyproject/#poetry-and-pep-517";
      requires = lib.attrByPath [ "build-system" "requires" ] (throw missingBuildBackendError) pyProject;
      requiredPkgs = builtins.map (n: lib.elemAt (builtins.match "([^!=<>~[]+).*" n) 0) requires;
    in
    builtins.map (drvAttr: pythonPackages.${drvAttr} or (throw "unsupported build system requirement ${drvAttr}")) requiredPkgs;

  # Find gitignore files recursively in parent directory stopping with .git
  findGitIgnores = path:
    let
      parent = path + "/..";
      gitIgnore = path + "/.gitignore";
      isGitRoot = builtins.pathExists (path + "/.git");
      hasGitIgnore = builtins.pathExists gitIgnore;
      gitIgnores = if hasGitIgnore then [ gitIgnore ] else [ ];
    in
    lib.optionals (builtins.pathExists path && builtins.toString path != "/" && ! isGitRoot) (findGitIgnores parent) ++ gitIgnores;

  /*
    Provides a source filtering mechanism that:

    - Filters gitignore's
    - Filters pycache/pyc files
    - Uses cleanSourceFilter to filter out .git/.hg, .o/.so, editor backup files & nix result symlinks
  */
  cleanPythonSources = { src }:
    let
      gitIgnores = findGitIgnores src;
      pycacheFilter = name: type:
        (type == "directory" && ! lib.strings.hasInfix "__pycache__" name)
        || (type == "regular" && ! lib.strings.hasSuffix ".pyc" name)
      ;
    in
    lib.cleanSourceWith {
      filter = lib.cleanSourceFilter;
      src = lib.cleanSourceWith {
        filter = pkgs.nix-gitignore.gitignoreFilterPure pycacheFilter gitIgnores src;
        inherit src;
      };
    };

  # Maps Nixpkgs CPU values to target machines known to be supported for manylinux* wheels.
  # (a.k.a. `uname -m` output from CentOS 7)
  #
  # This is current as of manylinux2014 (PEP-0599), and is a superset of manylinux2010 / manylinux1.
  # s390x is not supported in Nixpkgs, so we don't map it.
  manyLinuxTargetMachines = {
    x86_64 = "x86_64";
    i686 = "i686";
    aarch64 = "aarch64";
    armv7l = "armv7l";
    powerpc64 = "ppc64";
    powerpc64le = "ppc64le";
  };

  # Machine tag for our target platform (if available)
  getTargetMachine = stdenv: manyLinuxTargetMachines.${stdenv.targetPlatform.parsed.cpu.name} or null;

in
{
  inherit
    fetchFromPypi
    fetchFromLegacy
    getManyLinuxDeps
    isCompatible
    readTOML
    getBuildSystemPkgs
    satisfiesSemver
    cleanPythonSources
    normalizePackageName
    normalizePackageSet
    getPythonVersion
    getTargetMachine
    ;
}

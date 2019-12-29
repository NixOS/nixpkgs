{ autoPatchelfHook
, pkgs
, lib
, python
, buildPythonPackage
, pythonPackages
, poetryLib
}:
{ name
, version
, files
, source
, dependencies ? {}
, pythonPackages
, python-versions
, pwd
, supportedExtensions ? lib.importJSON ./extensions.json
, ...
}: let

  inherit (poetryLib) isCompatible getManyLinuxDeps fetchFromPypi;

  inherit (import ./pep425.nix {
    inherit lib python;
    inherit (pkgs) stdenv;
  }) selectWheel
    ;

  fileCandidates = let
    supportedRegex = ("^.*?(" + builtins.concatStringsSep "|" supportedExtensions + ")");
    matchesVersion = fname: builtins.match ("^.*" + builtins.replaceStrings [ "." ] [ "\\." ] version + ".*$") fname != null;
    hasSupportedExtension = fname: builtins.match supportedRegex fname != null;
  in
    builtins.filter (f: matchesVersion f.file && hasSupportedExtension f.file) files;

  toPath = s: pwd + "/${s}";

  isSource = source != null;
  isGit = isSource && source.type == "git";
  isLocal = isSource && source.type == "directory";

  localDepPath = toPath source.url;
  pyProject = poetryLib.readTOML (localDepPath + "/pyproject.toml");

  buildSystemPkgs = poetryLib.getBuildSystemPkgs {
    inherit pythonPackages pyProject;
  };

  fileInfo = let
    isBdist = f: lib.strings.hasSuffix "whl" f.file;
    isSdist = f: ! isBdist f;
    binaryDist = selectWheel fileCandidates;
    sourceDist = builtins.filter isSdist fileCandidates;
    lockFileEntry = if (builtins.length sourceDist) > 0 then builtins.head sourceDist else builtins.head binaryDist;
  in
    rec {
      inherit (lockFileEntry) file hash;
      name = file;
      format = if lib.strings.hasSuffix ".whl" name then "wheel" else "setuptools";
      kind = if format == "setuptools" then "source" else (builtins.elemAt (lib.strings.splitString "-" name) 2);
    };

in
buildPythonPackage {
  pname = name;
  version = version;

  doCheck = false; # We never get development deps
  dontStrip = true;
  format = if isLocal then "pyproject" else if isGit then "setuptools" else fileInfo.format;

  nativeBuildInputs = if (!isSource && (getManyLinuxDeps fileInfo.name).str != null) then [ autoPatchelfHook ] else [];
  buildInputs = if !isSource then (getManyLinuxDeps fileInfo.name).pkg else [];

  propagatedBuildInputs =
    let
      # Some dependencies like django gets the attribute name django
      # but dependencies try to access Django
      deps = builtins.map (d: lib.toLower d) (builtins.attrNames dependencies);
    in
      (builtins.map (n: pythonPackages.${n}) deps) ++ (if isLocal then buildSystemPkgs else []);

  meta = {
    broken = ! isCompatible python.version python-versions;
    license = [];
  };

  # We need to retrieve kind from the interpreter and the filename of the package
  # Interpreters should declare what wheel types they're compatible with (python type + ABI)
  # Here we can then choose a file based on that info.
  src = if isGit then (
    builtins.fetchGit {
      inherit (source) url;
      rev = source.reference;
    }
  ) else if isLocal then (localDepPath) else fetchFromPypi {
    pname = name;
    inherit (fileInfo) file hash kind;
  };
}

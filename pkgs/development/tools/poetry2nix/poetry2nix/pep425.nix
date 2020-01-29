{ lib, stdenv, python, isLinux ? stdenv.isLinux }:

let
  inherit (lib.strings) hasSuffix hasInfix splitString removeSuffix;

  # The 'cpxy" as determined by `python.version`
  #
  # e.g "2.7.17" -> "cp27"
  #     "3.5.9"  -> "cp35"
  pythonTag =
    let
      ver = builtins.splitVersion python.version;
      major = builtins.elemAt ver 0;
      minor = builtins.elemAt ver 1;
    in
      "cp${major}${minor}";

  abiTag = "${pythonTag}m";

  #
  # Parses wheel file returning an attribute set
  #
  toWheelAttrs = str:
    let
      entries = splitString "-" str;
      p = removeSuffix ".whl" (builtins.elemAt entries 4);
    in
      {
        pkgName = builtins.elemAt entries 0;
        pkgVer = builtins.elemAt entries 1;
        pyVer = builtins.elemAt entries 2;
        abi = builtins.elemAt entries 3;
        platform = p;
      };

  #
  # Builds list of acceptable osx wheel files
  #
  # <versions>   accepted versions in descending order of preference
  # <candidates> list of wheel files to select from
  findBestMatches = versions: candidates:
    let
      v = lib.lists.head versions;
      vs = lib.lists.tail versions;
    in
      if (builtins.length versions == 0)
      then []
      else (builtins.filter (x: hasInfix v x.file) candidates) ++ (findBestMatches vs candidates);

  # pyver = "cpXX"
  # x     = "cpXX" | "py2" | "py3" | "py2.py3"
  isPyVersionCompatible = pyver: x:
    let
      normalize = y: ''cp${lib.strings.removePrefix "cp" (lib.strings.removePrefix "py" y)}'';
      isCompat = p: x: lib.strings.hasPrefix (normalize x) p;
    in
      lib.lists.any (isCompat pyver) (lib.strings.splitString "." x);

  #
  # Selects the best matching wheel file from a list of files
  #
  selectWheel = files:
    let
      filesWithoutSources = (builtins.filter (x: hasSuffix ".whl" x.file) files);

      isPyAbiCompatible = pyabi: x: x == "none" || pyabi == x;

      withPython = ver: abi: x: (isPyVersionCompatible ver x.pyVer) && (isPyAbiCompatible abi x.abi);

      withPlatform = if isLinux
      then (
        x: x.platform == "manylinux1_${stdenv.platform.kernelArch}"
        || x.platform == "manylinux2010_${stdenv.platform.kernelArch}"
        || x.platform == "manylinux2014_${stdenv.platform.kernelArch}"
        || x.platform == "any"
      )
      else (x: hasInfix "macosx" x.platform || x.platform == "any");

      filterWheel = x:
        let
          f = toWheelAttrs x.file;
        in
          (withPython pythonTag abiTag f) && (withPlatform f);

      filtered = builtins.filter filterWheel filesWithoutSources;

      choose = files:
        let
          osxMatches = [ "10_12" "10_11" "10_10" "10_9" "any" ];
          linuxMatches = [ "manylinux1_" "manylinux2010_" "manylinux2014_" "any" ];
          chooseLinux = x: lib.singleton (builtins.head (findBestMatches linuxMatches x));
          chooseOSX = x: lib.singleton (builtins.head (findBestMatches osxMatches x));
        in
          if isLinux
          then chooseLinux files
          else chooseOSX files;

    in
      if (builtins.length filtered == 0)
      then []
      else choose (filtered);

in
{
  inherit selectWheel toWheelAttrs isPyVersionCompatible;
}

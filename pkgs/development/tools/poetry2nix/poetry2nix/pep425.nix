{ lib, stdenv, poetryLib, python, isLinux ? stdenv.isLinux }:
let
  inherit (lib.strings) escapeRegex hasPrefix hasSuffix hasInfix splitString removePrefix removeSuffix;
  targetMachine = poetryLib.getTargetMachine stdenv;

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
      entries' = splitString "-" str;
      # Hack: Remove version "suffixes" like 2.11.4-1
      # Some wheels have build tag with more than one digit
      # like openvino-2022.1.0-7019-cp36-cp36m-manylinux_2_27_x86_64.whl
      entries = builtins.filter (x: builtins.match "[0-9]*" x == null) entries';
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
    then [ ]
    else (builtins.filter (x: hasInfix v x.file) candidates) ++ (findBestMatches vs candidates);

  # pyver = "cpXX"
  # x     = "cpXX" | "py2" | "py3" | "py2.py3"
  isPyVersionCompatible = pyver: x:
    let
      normalize = y: ''cp${removePrefix "cp" (removePrefix "py" y)}'';
      isCompat = p: x: hasPrefix (normalize x) p;
    in
    lib.lists.any (isCompat pyver) (splitString "." x);

  #
  # Selects the best matching wheel file from a list of files
  #
  selectWheel = files:
    let
      filesWithoutSources = (builtins.filter (x: hasSuffix ".whl" x.file) files);
      isPyAbiCompatible = pyabi: x: x == "none" || hasPrefix pyabi x || hasPrefix x pyabi || (
        # The CPython stable ABI is abi3 as in the shared library suffix.
        python.passthru.implementation == "cpython" &&
          builtins.elemAt (lib.splitString "." python.version) 0 == "3" &&
          x == "abi3"
      );
      withPython = ver: abi: x: (isPyVersionCompatible ver x.pyVer) && (isPyAbiCompatible abi x.abi);
      withPlatform =
        if isLinux
        then
          if targetMachine != null
          then
          # See PEP 600 for details.
            (p:
              builtins.match "any|manylinux(1|2010|2014)_${escapeRegex targetMachine}|manylinux_[0-9]+_[0-9]+_${escapeRegex targetMachine}" p != null
            )
          else
            (p: p == "any")
        else
          if stdenv.isDarwin
          then
            if stdenv.targetPlatform.isAarch64
            then (p: p == "any" || (hasInfix "macosx" p && lib.lists.any (e: hasSuffix e p) [ "arm64" "aarch64" ]))
            else (p: p == "any" || (hasInfix "macosx" p && hasSuffix "x86_64" p))
          else (p: p == "any");
      withPlatforms = x: lib.lists.any withPlatform (splitString "." x.platform);
      filterWheel = x:
        let
          f = toWheelAttrs x.file;
        in
        (withPython pythonTag abiTag f) && (withPlatforms f);
      filtered = builtins.filter filterWheel filesWithoutSources;
      choose = files:
        let
          osxMatches = [ "12_0" "11_0" "10_12" "10_11" "10_10" "10_9" "10_8" "10_7" "any" ];
          linuxMatches = [ "manylinux1_" "manylinux2010_" "manylinux2014_" "manylinux_" "any" ];
          chooseLinux = x: lib.take 1 (findBestMatches linuxMatches x);
          chooseOSX = x: lib.take 1 (findBestMatches osxMatches x);
        in
        if isLinux
        then chooseLinux files
        else chooseOSX files;
    in
    if (builtins.length filtered == 0)
    then [ ]
    else choose (filtered);
in
{
  inherit selectWheel toWheelAttrs isPyVersionCompatible;
}

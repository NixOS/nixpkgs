{ autoPatchelfHook
, lib
, python
, buildPythonPackage
, poetryLib
, evalPep508
}:
{ name
, version
, files
, source
, dependencies ? { }
, pythonPackages
, python-versions
, pwd
, sourceSpec
, supportedExtensions ? lib.importJSON ./extensions.json
, preferWheels ? false
, ...
}:

pythonPackages.callPackage
  (
    { preferWheel ? preferWheels
    , ...
    }@args:
    let
      inherit (python) stdenv;
      inherit (poetryLib) isCompatible getManyLinuxDeps fetchFromLegacy fetchFromPypi normalizePackageName;

      inherit (import ./pep425.nix {
        inherit lib poetryLib python stdenv;
      }) selectWheel
        ;
      fileCandidates =
        let
          supportedRegex = ("^.*(" + builtins.concatStringsSep "|" supportedExtensions + ")");
          matchesVersion = fname: builtins.match ("^.*" + builtins.replaceStrings [ "." "+" ] [ "\\." "\\+" ] version + ".*$") fname != null;
          hasSupportedExtension = fname: builtins.match supportedRegex fname != null;
          isCompatibleEgg = fname: ! lib.strings.hasSuffix ".egg" fname || lib.strings.hasSuffix "py${python.pythonVersion}.egg" fname;
        in
        builtins.filter (f: matchesVersion f.file && hasSupportedExtension f.file && isCompatibleEgg f.file) files;
      toPath = s: pwd + "/${s}";
      isLocked = lib.length fileCandidates > 0;
      isSource = source != null;
      isGit = isSource && source.type == "git";
      isUrl = isSource && source.type == "url";
      isDirectory = isSource && source.type == "directory";
      isFile = isSource && source.type == "file";
      isLegacy = isSource && source.type == "legacy";
      localDepPath = toPath source.url;

      buildSystemPkgs =
        let
          pyProjectPath = localDepPath + "/pyproject.toml";
          pyProject = poetryLib.readTOML pyProjectPath;
        in
        if builtins.pathExists pyProjectPath then
          poetryLib.getBuildSystemPkgs
            {
              inherit pythonPackages pyProject;
            } else [ ];

      fileInfo =
        let
          isBdist = f: lib.strings.hasSuffix "whl" f.file;
          isSdist = f: ! isBdist f && ! isEgg f;
          isEgg = f: lib.strings.hasSuffix ".egg" f.file;
          binaryDist = selectWheel fileCandidates;
          sourceDist = builtins.filter isSdist fileCandidates;
          eggs = builtins.filter isEgg fileCandidates;
          entries = (if preferWheel then binaryDist ++ sourceDist else sourceDist ++ binaryDist) ++ eggs;
          lockFileEntry = (
            if lib.length entries > 0 then builtins.head entries
            else throw "Missing suitable source/wheel file entry for ${name}"
          );
          _isEgg = isEgg lockFileEntry;
        in
        rec {
          inherit (lockFileEntry) file hash;
          name = file;
          format =
            if _isEgg then "egg"
            else if lib.strings.hasSuffix ".whl" name then "wheel"
            else "pyproject";
          kind =
            if _isEgg then python.pythonVersion
            else if format == "pyproject" then "source"
            else (builtins.elemAt (lib.strings.splitString "-" name) 2);
        };

      format = if isDirectory || isGit || isUrl then "pyproject" else fileInfo.format;

      hooks = python.pkgs.callPackage ./hooks { };
    in
    buildPythonPackage {
      pname = normalizePackageName name;
      version = version;

      # Circumvent output separation (https://github.com/NixOS/nixpkgs/pull/190487)
      format = if format == "pyproject" then "poetry2nix" else format;

      doCheck = false; # We never get development deps

      # Stripping pre-built wheels lead to `ELF load command address/offset not properly aligned`
      dontStrip = format == "wheel";

      nativeBuildInputs = [
        hooks.poetry2nixFixupHook
      ]
      ++ lib.optional (isLocked && (getManyLinuxDeps fileInfo.name).str != null) autoPatchelfHook
      ++ lib.optionals (format == "wheel") [
        hooks.wheelUnpackHook
        pythonPackages.pipInstallHook
        pythonPackages.setuptools
      ]
      ++ lib.optionals (format == "pyproject") [
        hooks.removePathDependenciesHook
        hooks.removeGitDependenciesHook
        hooks.pipBuildHook
      ];

      buildInputs = (
        lib.optional (isLocked) (getManyLinuxDeps fileInfo.name).pkg
        ++ lib.optional isDirectory buildSystemPkgs
        ++ lib.optional (stdenv.buildPlatform != stdenv.hostPlatform) pythonPackages.setuptools
      );

      propagatedBuildInputs =
        let
          compat = isCompatible (poetryLib.getPythonVersion python);
          deps = lib.filterAttrs
            (n: v: v)
            (
              lib.mapAttrs
                (
                  n: v:
                    let
                      constraints = v.python or "";
                      pep508Markers = v.markers or "";
                    in
                    compat constraints && evalPep508 pep508Markers
                )
                dependencies
            );
          depAttrs = lib.attrNames deps;
        in
        builtins.map (n: pythonPackages.${normalizePackageName n}) depAttrs;

      meta = {
        broken = ! isCompatible (poetryLib.getPythonVersion python) python-versions;
        license = [ ];
        inherit (python.meta) platforms;
      };

      passthru = {
        inherit args;
      };

      # We need to retrieve kind from the interpreter and the filename of the package
      # Interpreters should declare what wheel types they're compatible with (python type + ABI)
      # Here we can then choose a file based on that info.
      src =
        if isGit then
          (
            builtins.fetchGit ({
              inherit (source) url;
              submodules = true;
              rev = source.resolved_reference or source.reference;
              ref = sourceSpec.branch or (if sourceSpec ? tag then "refs/tags/${sourceSpec.tag}" else "HEAD");
            } // (
              lib.optionalAttrs ((sourceSpec ? rev) && (lib.versionAtLeast builtins.nixVersion "2.4")) {
                allRefs = true;
              }
            ))
          )
        else if isUrl then
          builtins.fetchTarball
            {
              inherit (source) url;
            }
        else if isDirectory then
          (poetryLib.cleanPythonSources { src = localDepPath; })
        else if isFile then
          localDepPath
        else if isLegacy then
          fetchFromLegacy
            {
              pname = name;
              inherit python;
              inherit (fileInfo) file hash;
              inherit (source) url;
            }
        else
          fetchFromPypi {
            pname = name;
            inherit (fileInfo) file hash kind;
            inherit version;
          };
    }
  )
{ }

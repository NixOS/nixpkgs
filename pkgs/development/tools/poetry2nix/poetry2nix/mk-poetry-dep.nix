{ autoPatchelfHook
, pkgs
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
, __isBootstrap ? false  # Hack: Always add Poetry as a build input unless bootstrapping
, ...
}:

pythonPackages.callPackage
  (
    { preferWheel ? preferWheels
    , ...
    }@args:
    let
      inherit (pkgs) stdenv;
      inherit (poetryLib) isCompatible getManyLinuxDeps fetchFromPypi moduleName;

      inherit (import ./pep425.nix {
        inherit lib python;
        inherit (pkgs) stdenv;
      }) selectWheel
        ;
      fileCandidates =
        let
          supportedRegex = ("^.*?(" + builtins.concatStringsSep "|" supportedExtensions + ")");
          matchesVersion = fname: builtins.match ("^.*" + builtins.replaceStrings [ "." ] [ "\\." ] version + ".*$") fname != null;
          hasSupportedExtension = fname: builtins.match supportedRegex fname != null;
          isCompatibleEgg = fname: ! lib.strings.hasSuffix ".egg" fname || lib.strings.hasSuffix "py${python.pythonVersion}.egg" fname;
        in
        builtins.filter (f: matchesVersion f.file && hasSupportedExtension f.file && isCompatibleEgg f.file) files;
      toPath = s: pwd + "/${s}";
      isSource = source != null;
      isGit = isSource && source.type == "git";
      isUrl = isSource && source.type == "url";
      isLocal = isSource && source.type == "directory";
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
          lockFileEntry = builtins.head entries;
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

      # Prevent infinite recursion
      skipSetupToolsSCM = [
        "setuptools_scm"
        "setuptools-scm"
        "toml" # Toml is an extra for setuptools-scm
      ];
      baseBuildInputs = lib.optional (! lib.elem name skipSetupToolsSCM) pythonPackages.setuptools-scm;
      format = if isLocal || isGit || isUrl then "pyproject" else fileInfo.format;
    in
    buildPythonPackage {
      pname = moduleName name;
      version = version;

      inherit format;

      doCheck = false; # We never get development deps

      # Stripping pre-built wheels lead to `ELF load command address/offset not properly aligned`
      dontStrip = format == "wheel";

      nativeBuildInputs = [
        pythonPackages.poetry2nixFixupHook
      ]
      ++ lib.optional (!isSource && (getManyLinuxDeps fileInfo.name).str != null) autoPatchelfHook
      ++ lib.optional (format == "pyproject") pythonPackages.removePathDependenciesHook
      ;

      buildInputs = (
        baseBuildInputs
        ++ lib.optional (stdenv.buildPlatform != stdenv.hostPlatform) pythonPackages.setuptools
        ++ lib.optional (!isSource) (getManyLinuxDeps fileInfo.name).pkg
        ++ lib.optional isLocal buildSystemPkgs
        ++ lib.optional (!__isBootstrap) pythonPackages.poetry
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
        builtins.map (n: pythonPackages.${moduleName n}) depAttrs;

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
            builtins.fetchGit {
              inherit (source) url;
              rev = source.resolved_reference or source.reference;
              ref = sourceSpec.branch or sourceSpec.rev or sourceSpec.tag or "HEAD";
            }
          )
        else if isUrl then
          builtins.fetchTarball
            {
              inherit (source) url;
            }
        else if isLocal then
          (poetryLib.cleanPythonSources { src = localDepPath; })
        else
          fetchFromPypi {
            pname = name;
            inherit (fileInfo) file hash kind;
          };
    }
  )
{ }

{ pkgs ? import <nixpkgs> {}
, lib ? pkgs.lib
, poetry ? null
, poetryLib ? import ./lib.nix { inherit lib pkgs; }
}:
let
  inherit (poetryLib) isCompatible readTOML;

  # Poetry2nix version
  version = "1.6.0";

  /* The default list of poetry2nix override overlays */
  defaultPoetryOverrides = (import ./overrides.nix { inherit pkgs lib; });

  mkEvalPep508 = import ./pep508.nix {
    inherit lib poetryLib;
    stdenv = pkgs.stdenv;
  };

  getFunctorFn = fn: if builtins.typeOf fn == "set" then fn.__functor else fn;

  # Map SPDX identifiers to license names
  spdxLicenses = lib.listToAttrs (lib.filter (pair: pair.name != null) (builtins.map (v: { name = if lib.hasAttr "spdxId" v then v.spdxId else null; value = v; }) (lib.attrValues lib.licenses)));
  # Get license by id falling back to input string
  getLicenseBySpdxId = spdxId: spdxLicenses.${spdxId} or spdxId;

  /*
     Returns an attrset { python, poetryPackages, pyProject, poetryLock } for the given pyproject/lockfile.
  */
  mkPoetryPackages =
    { projectDir ? null
    , pyproject ? projectDir + "/pyproject.toml"
    , poetrylock ? projectDir + "/poetry.lock"
    , overrides ? [ defaultPoetryOverrides ]
    , python ? pkgs.python3
    , pwd ? projectDir
    }@attrs: let
      poetryPkg = poetry.override { inherit python; };

      pyProject = readTOML pyproject;
      poetryLock = readTOML poetrylock;
      lockFiles = lib.getAttrFromPath [ "metadata" "files" ] poetryLock;

      specialAttrs = [
        "overrides"
        "poetrylock"
        "pwd"
      ];
      passedAttrs = builtins.removeAttrs attrs specialAttrs;

      evalPep508 = mkEvalPep508 python;

      # Filter packages by their PEP508 markers & pyproject interpreter version
      partitions = let
        supportsPythonVersion = pkgMeta: if pkgMeta ? marker then (evalPep508 pkgMeta.marker) else true;
      in
        lib.partition supportsPythonVersion poetryLock.package;

      compatible = partitions.right;
      incompatible = partitions.wrong;

      # Create an overriden version of pythonPackages
      #
      # We need to avoid mixing multiple versions of pythonPackages in the same
      # closure as python can only ever have one version of a dependency
      baseOverlay = self: super:
        let
          getDep = depName: self.${depName};

          lockPkgs = builtins.listToAttrs (
            builtins.map (
              pkgMeta: rec {
                name = pkgMeta.name;
                value = self.mkPoetryDep (
                  pkgMeta // {
                    inherit pwd;
                    source = pkgMeta.source or null;
                    files = lockFiles.${name};
                    pythonPackages = self;
                  }
                );
              }
            ) compatible
          );
        in
          lockPkgs;
      overlays = builtins.map getFunctorFn (
        [
          (
            self: super: let
              hooks = self.callPackage ./hooks {};
            in
              {
                mkPoetryDep = self.callPackage ./mk-poetry-dep.nix {
                  inherit pkgs lib python poetryLib;
                };
                poetry = poetryPkg;
                # The canonical name is setuptools-scm
                setuptools-scm = super.setuptools_scm;

                inherit (hooks) removePathDependenciesHook poetry2nixFixupHook;
              }
          )
          # Null out any filtered packages, we don't want python.pkgs from nixpkgs
          (self: super: builtins.listToAttrs (builtins.map (x: { name = x.name; value = null; }) incompatible))
          # Create poetry2nix layer
          baseOverlay
        ] ++ # User provided overrides
        overrides
      );

      packageOverrides = lib.foldr lib.composeExtensions (self: super: {}) overlays;

      py = python.override { inherit packageOverrides; self = py; };
    in
      {
        python = py;
        poetryPackages = map (pkg: py.pkgs.${pkg.name}) compatible;
        poetryLock = poetryLock;
        inherit pyProject;
      };

  /* Returns a package with a python interpreter and all packages specified in the poetry.lock lock file.

     Example:
       poetry2nix.mkPoetryEnv { poetrylock = ./poetry.lock; python = python3; }
  */
  mkPoetryEnv =
    { projectDir ? null
    , pyproject ? projectDir + "/pyproject.toml"
    , poetrylock ? projectDir + "/poetry.lock"
    , overrides ? [ defaultPoetryOverrides ]
    , pwd ? projectDir
    , python ? pkgs.python3
    }:
      let
        py = mkPoetryPackages (
          {
            inherit pyproject poetrylock overrides python pwd;
          }
        );
      in
        py.python.withPackages (_: py.poetryPackages);

  /* Creates a Python application from pyproject.toml and poetry.lock */
  mkPoetryApplication =
    { projectDir ? null
    , src ? poetryLib.cleanPythonSources { src = projectDir; }
    , pyproject ? projectDir + "/pyproject.toml"
    , poetrylock ? projectDir + "/poetry.lock"
    , overrides ? [ defaultPoetryOverrides ]
    , meta ? {}
    , python ? pkgs.python3
    , pwd ? projectDir
    , ...
    }@attrs: let
      poetryPython = mkPoetryPackages {
        inherit pyproject poetrylock overrides python pwd;
      };
      py = poetryPython.python;

      inherit (poetryPython) pyProject;

      specialAttrs = [
        "overrides"
        "poetrylock"
        "pwd"
        "pyproject"
      ];
      passedAttrs = builtins.removeAttrs attrs specialAttrs;

      # Get dependencies and filter out depending on interpreter version
      getDeps = depAttr: let
        compat = isCompatible py.pythonVersion;
        deps = pyProject.tool.poetry.${depAttr} or {};
        depAttrs = builtins.map (d: lib.toLower d) (builtins.attrNames deps);
      in
        builtins.map (
          dep: let
            pkg = py.pkgs."${dep}";
            constraints = deps.${dep}.python or "";
            isCompat = compat constraints;
          in
            if isCompat then pkg else null
        ) depAttrs;

      getInputs = attr: attrs.${attr} or [];
      mkInput = attr: extraInputs: getInputs attr ++ extraInputs;

      buildSystemPkgs = poetryLib.getBuildSystemPkgs {
        inherit pyProject;
        pythonPackages = py.pkgs;
      };

    in
      py.pkgs.buildPythonApplication (
        passedAttrs // {
          pname = pyProject.tool.poetry.name;
          version = pyProject.tool.poetry.version;

          inherit src;

          format = "pyproject";

          buildInputs = mkInput "buildInputs" buildSystemPkgs;
          propagatedBuildInputs = mkInput "propagatedBuildInputs" (getDeps "dependencies") ++ ([ py.pkgs.setuptools ]);
          nativeBuildInputs = mkInput "nativeBuildInputs" [ pkgs.yj py.pkgs.removePathDependenciesHook ];
          checkInputs = mkInput "checkInputs" (getDeps "dev-dependencies");

          passthru = {
            python = py;
          };

          meta = meta // {
            inherit (pyProject.tool.poetry) description homepage;
            inherit (py.meta) platforms;
            license = getLicenseBySpdxId (pyProject.tool.poetry.license or "unknown");
          };

        }
      );

  /* Poetry2nix CLI used to supplement SHA-256 hashes for git dependencies  */
  cli = import ./cli.nix { inherit pkgs lib version; };

in
{
  inherit mkPoetryEnv mkPoetryApplication mkPoetryPackages cli version;

  inherit (poetryLib) cleanPythonSources;

  /*
  The default list of poetry2nix override overlays

  Can be overriden by calling defaultPoetryOverrides.overrideOverlay which takes an overlay function
  */
  defaultPoetryOverrides = {
    __functor = defaultPoetryOverrides;
    overrideOverlay = fn: self: super: let
      defaultSet = defaultPoetryOverrides self super;
      customSet = fn self super;
    in
      defaultSet // customSet;
  };

  /*
  Convenience functions for specifying overlays with or without the poerty2nix default overrides
  */
  overrides = {
    /*
    Returns the specified overlay in a list
    */
    withoutDefaults = overlay: [
      overlay
    ];

    /*
    Returns the specified overlay and returns a list
    combining it with poetry2nix default overrides
    */
    withDefaults = overlay: [
      defaultPoetryOverrides
      overlay
    ];
  };
}

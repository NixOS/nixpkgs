{ pkgs ? import <nixpkgs> { }
, lib ? pkgs.lib
, poetry ? null
, poetryLib ? import ./lib.nix { inherit lib pkgs; }
}:
let
  inherit (poetryLib) isCompatible readTOML moduleName;

  /* The default list of poetry2nix override overlays */
  mkEvalPep508 = import ./pep508.nix {
    inherit lib poetryLib;
    stdenv = pkgs.stdenv;
  };
  getFunctorFn = fn: if builtins.typeOf fn == "set" then fn.__functor else fn;

  # Map SPDX identifiers to license names
  spdxLicenses = lib.listToAttrs (lib.filter (pair: pair.name != null) (builtins.map (v: { name = if lib.hasAttr "spdxId" v then v.spdxId else null; value = v; }) (lib.attrValues lib.licenses)));
  # Get license by id falling back to input string
  getLicenseBySpdxId = spdxId: spdxLicenses.${spdxId} or spdxId;

  # Experimental withPlugins functionality
  toPluginAble = (import ./plugins.nix { inherit pkgs lib; }).toPluginAble;
in
lib.makeScope pkgs.newScope (self: {

  # Poetry2nix version
  version = "1.11.0";

  /*
     Returns an attrset { python, poetryPackages, pyProject, poetryLock } for the given pyproject/lockfile.
  */
  mkPoetryPackages =
    { projectDir ? null
    , pyproject ? projectDir + "/pyproject.toml"
    , poetrylock ? projectDir + "/poetry.lock"
    , overrides ? self.defaultPoetryOverrides
    , python ? pkgs.python3
    , pwd ? projectDir
    , preferWheels ? false
    , __isBootstrap ? false  # Hack: Always add Poetry as a build input unless bootstrapping
    }@attrs:
    let
      poetryPkg = poetry.override { inherit python; };
      pyProject = readTOML pyproject;
      poetryLock = readTOML poetrylock;
      lockFiles =
        let
          lockfiles = lib.getAttrFromPath [ "metadata" "files" ] poetryLock;
        in
        lib.listToAttrs (lib.mapAttrsToList (n: v: { name = moduleName n; value = v; }) lockfiles);
      specialAttrs = [
        "overrides"
        "poetrylock"
        "projectDir"
        "pwd"
        "preferWheels"
      ];
      passedAttrs = builtins.removeAttrs attrs specialAttrs;
      evalPep508 = mkEvalPep508 python;

      # Filter packages by their PEP508 markers & pyproject interpreter version
      partitions =
        let
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
            builtins.map
              (
                pkgMeta: rec {
                  name = moduleName pkgMeta.name;
                  value = self.mkPoetryDep (
                    pkgMeta // {
                      inherit pwd preferWheels;
                      inherit __isBootstrap;
                      source = pkgMeta.source or null;
                      files = lockFiles.${name};
                      pythonPackages = self;
                      sourceSpec = pyProject.tool.poetry.dependencies.${name} or pyProject.tool.poetry.dev-dependencies.${name} or { };
                    }
                  );
                }
              )
              compatible
          );
        in
        lockPkgs;
      overlays = builtins.map
        getFunctorFn
        (
          [
            (
              self: super:
                let
                  hooks = self.callPackage ./hooks { };
                in
                {
                  mkPoetryDep = self.callPackage ./mk-poetry-dep.nix {
                    inherit pkgs lib python poetryLib;
                  };
                  poetry = poetryPkg;
                  # The canonical name is setuptools-scm
                  setuptools-scm = super.setuptools_scm;

                  __toPluginAble = toPluginAble self;

                  inherit (hooks) pipBuildHook removePathDependenciesHook poetry2nixFixupHook;
                }
            )
            # Null out any filtered packages, we don't want python.pkgs from nixpkgs
            (self: super: builtins.listToAttrs (builtins.map (x: { name = moduleName x.name; value = null; }) incompatible))
            # Create poetry2nix layer
            baseOverlay
          ] ++ # User provided overrides
          (if builtins.typeOf overrides == "list" then overrides else [ overrides ])
        );
      packageOverrides = lib.foldr lib.composeExtensions (self: super: { }) overlays;
      py = python.override { inherit packageOverrides; self = py; };
    in
    {
      python = py;
      poetryPackages = map (pkg: py.pkgs.${moduleName pkg.name}) compatible;
      poetryLock = poetryLock;
      inherit pyProject;
    };

  /* Returns a package with a python interpreter and all packages specified in the poetry.lock lock file.
     In editablePackageSources you can pass a mapping from package name to source directory to have
     those packages available in the resulting environment, whose source changes are immediately available.

     Example:
       poetry2nix.mkPoetryEnv { poetrylock = ./poetry.lock; python = python3; }
  */
  mkPoetryEnv =
    { projectDir ? null
    , pyproject ? projectDir + "/pyproject.toml"
    , poetrylock ? projectDir + "/poetry.lock"
    , overrides ? self.defaultPoetryOverrides
    , pwd ? projectDir
    , python ? pkgs.python3
    , preferWheels ? false
      # Example: { my-app = ./src; }
    , editablePackageSources ? { }
    }:
    let
      py = self.mkPoetryPackages (
        {
          inherit pyproject poetrylock overrides python pwd preferWheels;
        }
      );

      editablePackage = import ./editable.nix {
        inherit pkgs lib poetryLib editablePackageSources;
        inherit (py) pyProject python;
      };

    in
    py.python.withPackages (_: py.poetryPackages ++ lib.optional (editablePackageSources != { }) editablePackage);

  /* Creates a Python application from pyproject.toml and poetry.lock

     The result also contains a .dependencyEnv attribute which is a python
     environment of all dependencies and this apps modules. This is useful if
     you rely on dependencies to invoke your modules for deployment: e.g. this
     allows `gunicorn my-module:app`.
  */
  mkPoetryApplication =
    { projectDir ? null
    , src ? self.cleanPythonSources { src = projectDir; }
    , pyproject ? projectDir + "/pyproject.toml"
    , poetrylock ? projectDir + "/poetry.lock"
    , overrides ? self.defaultPoetryOverrides
    , meta ? { }
    , python ? pkgs.python3
    , pwd ? projectDir
    , preferWheels ? false
    , __isBootstrap ? false  # Hack: Always add Poetry as a build input unless bootstrapping
    , ...
    }@attrs:
    let
      poetryPython = self.mkPoetryPackages {
        inherit pyproject poetrylock overrides python pwd preferWheels __isBootstrap;
      };
      py = poetryPython.python;

      inherit (poetryPython) pyProject;
      specialAttrs = [
        "overrides"
        "poetrylock"
        "projectDir"
        "pwd"
        "pyproject"
        "preferWheels"
      ];
      passedAttrs = builtins.removeAttrs attrs specialAttrs;

      # Get dependencies and filter out depending on interpreter version
      getDeps = depAttr:
        let
          compat = isCompatible (poetryLib.getPythonVersion py);
          deps = pyProject.tool.poetry.${depAttr} or { };
          depAttrs = builtins.map (d: lib.toLower d) (builtins.attrNames deps);
        in
        builtins.map
          (
            dep:
            let
              pkg = py.pkgs."${moduleName dep}";
              constraints = deps.${dep}.python or "";
              isCompat = compat constraints;
            in
            if isCompat then pkg else null
          )
          depAttrs;
      getInputs = attr: attrs.${attr} or [ ];
      mkInput = attr: extraInputs: getInputs attr ++ extraInputs;
      buildSystemPkgs = poetryLib.getBuildSystemPkgs {
        inherit pyProject;
        pythonPackages = py.pkgs;
      };
      app = py.pkgs.buildPythonPackage (
        passedAttrs // {
          pname = moduleName pyProject.tool.poetry.name;
          version = pyProject.tool.poetry.version;

          inherit src;

          format = "pyproject";
          # Like buildPythonApplication, but without the toPythonModule part
          # Meaning this ends up looking like an application but it also
          # provides python modules
          namePrefix = "";

          buildInputs = mkInput "buildInputs" buildSystemPkgs;
          propagatedBuildInputs = mkInput "propagatedBuildInputs" (getDeps "dependencies") ++ ([ py.pkgs.setuptools ]);
          nativeBuildInputs = mkInput "nativeBuildInputs" [ pkgs.yj py.pkgs.removePathDependenciesHook ];
          checkInputs = mkInput "checkInputs" (getDeps "dev-dependencies");

          passthru = {
            python = py;
            dependencyEnv = (
              lib.makeOverridable ({ app, ... }@attrs:
                let
                  args = builtins.removeAttrs attrs [ "app" ] // {
                    extraLibs = [ app ];
                  };
                in
                py.buildEnv.override args)
            ) { inherit app; };
          };

          meta = lib.optionalAttrs (lib.hasAttr "description" pyProject.tool.poetry) {
            inherit (pyProject.tool.poetry) description;
          } // lib.optionalAttrs (lib.hasAttr "homepage" pyProject.tool.poetry) {
            inherit (pyProject.tool.poetry) homepage;
          } // {
            inherit (py.meta) platforms;
            license = getLicenseBySpdxId (pyProject.tool.poetry.license or "unknown");
          } // meta;

        }
      );
    in
    app;

  /* Poetry2nix CLI used to supplement SHA-256 hashes for git dependencies  */
  cli = import ./cli.nix {
    inherit pkgs lib;
    inherit (self) version;
  };

  # inherit mkPoetryEnv mkPoetryApplication mkPoetryPackages;

  inherit (poetryLib) cleanPythonSources;


  /*
  Create a new default set of overrides with the same structure as the built-in ones
  */
  mkDefaultPoetryOverrides = defaults: {
    __functor = defaults;

    extend = overlay:
      let
        composed = lib.foldr lib.composeExtensions overlay [ defaults ];
      in
      self.mkDefaultPoetryOverrides composed;

    overrideOverlay = fn:
      let
        overlay = self: super:
          let
            defaultSet = defaults self super;
            customSet = fn self super;
          in
          defaultSet // customSet;
      in
      self.mkDefaultPoetryOverrides overlay;
  };

  /*
  The default list of poetry2nix override overlays

  Can be overriden by calling defaultPoetryOverrides.overrideOverlay which takes an overlay function
  */
  defaultPoetryOverrides = self.mkDefaultPoetryOverrides (import ./overrides.nix { inherit pkgs lib; });

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
      self.defaultPoetryOverrides
      overlay
    ];
  };
})

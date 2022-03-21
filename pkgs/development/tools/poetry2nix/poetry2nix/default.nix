{ pkgs ? import <nixpkgs> { }
, lib ? pkgs.lib
, poetry ? null
, poetryLib ? import ./lib.nix { inherit lib pkgs; stdenv = pkgs.stdenv; }
}:
let
  # Poetry2nix version
  version = "1.26.0";

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

  mkInputAttrs =
    { py
    , pyProject
    , attrs
    , includeBuildSystem ? true
    }:
    let
      getInputs = attr: attrs.${attr} or [ ];

      # Get dependencies and filter out depending on interpreter version
      getDeps = depAttr:
        let
          compat = isCompatible (poetryLib.getPythonVersion py);
          deps = pyProject.tool.poetry.${depAttr} or { };
          depAttrs = builtins.map (d: lib.toLower d) (builtins.attrNames deps);
        in
        (
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
            depAttrs
        );

      buildSystemPkgs = poetryLib.getBuildSystemPkgs {
        inherit pyProject;
        pythonPackages = py.pkgs;
      };

      mkInput = attr: extraInputs: getInputs attr ++ extraInputs;

    in
    {
      buildInputs = mkInput "buildInputs" (if includeBuildSystem then buildSystemPkgs else [ ]);
      propagatedBuildInputs = mkInput "propagatedBuildInputs" (getDeps "dependencies") ++ ([ py.pkgs.setuptools ]);
      nativeBuildInputs = mkInput "nativeBuildInputs" [ ];
      checkInputs = mkInput "checkInputs" (getDeps "dev-dependencies");
    };


in
lib.makeScope pkgs.newScope (self: {

  inherit version;

  /* Returns a package of editable sources whose changes will be available without needing to restart the
    nix-shell.
    In editablePackageSources you can pass a mapping from package name to source directory to have
    those packages available in the resulting environment, whose source changes are immediately available.

  */
  mkPoetryEditablePackage =
    { projectDir ? null
    , pyproject ? projectDir + "/pyproject.toml"
    , python ? pkgs.python3
    , pyProject ? readTOML pyproject
      # Example: { my-app = ./src; }
    , editablePackageSources
    }:
      assert editablePackageSources != { };
      import ./editable.nix {
        inherit pyProject python pkgs lib poetryLib editablePackageSources;
      };

  /* Returns a package containing scripts defined in tool.poetry.scripts.
  */
  mkPoetryScriptsPackage =
    { projectDir ? null
    , pyproject ? projectDir + "/pyproject.toml"
    , python ? pkgs.python3
    , pyProject ? readTOML pyproject
    , scripts ? pyProject.tool.poetry.scripts
    }:
      assert scripts != { };
      import ./shell-scripts.nix {
        inherit lib python scripts;
      };

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
      # Example: { my-app = ./src; }
    , editablePackageSources ? { }
    , __isBootstrap ? false  # Hack: Always add Poetry as a build input unless bootstrapping
    , pyProject ? readTOML pyproject
    }@attrs:
    let
      poetryPkg = poetry.override { inherit python; };

      scripts = pyProject.tool.poetry.scripts or { };
      hasScripts = scripts != { };
      scriptsPackage = self.mkPoetryScriptsPackage {
        inherit python scripts;
      };

      editablePackageSources' = lib.filterAttrs (name: path: path != null) editablePackageSources;
      hasEditable = editablePackageSources' != { };
      editablePackage = self.mkPoetryEditablePackage {
        inherit pyProject python;
        editablePackageSources = editablePackageSources';
      };

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
          supportsPythonVersion = pkgMeta: if pkgMeta ? marker then (evalPep508 pkgMeta.marker) else true && isCompatible (poetryLib.getPythonVersion python) pkgMeta.python-versions;
        in
        lib.partition supportsPythonVersion poetryLock.package;
      compatible = partitions.right;
      incompatible = partitions.wrong;

      # Create an overridden version of pythonPackages
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
              (lib.reverseList compatible)
          );
        in
        lockPkgs // {
          # Create a dummy null package for the current project in case any dependencies depend on the root project (issue #307)
          ${pyProject.tool.poetry.name} = null;
        };
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
                    inherit pkgs lib python poetryLib evalPep508;
                  };

                  # Use poetry-core from the poetry build (pep517/518 build-system)
                  poetry-core = if __isBootstrap then null else poetryPkg.passthru.python.pkgs.poetry-core;
                  poetry = if __isBootstrap then null else poetryPkg;

                  __toPluginAble = toPluginAble self;

                  inherit (hooks) pipBuildHook removePathDependenciesHook removeGitDependenciesHook poetry2nixFixupHook wheelUnpackHook;
                } // lib.optionalAttrs (! super ? setuptools-scm) {
                  # The canonical name is setuptools-scm
                  setuptools-scm = super.setuptools_scm;
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

      inputAttrs = mkInputAttrs { inherit py pyProject; attrs = { }; includeBuildSystem = false; };

      requiredPythonModules = python.pkgs.requiredPythonModules;
      /* Include all the nested dependencies which are required for each package.
        This guarantees that using the "poetryPackages" attribute will return
        complete list of dependencies for the poetry project to be portable.
      */
      storePackages = requiredPythonModules (builtins.foldl' (acc: v: acc ++ v) [ ] (lib.attrValues inputAttrs));
    in
    {
      python = py;
      poetryPackages = storePackages
        ++ lib.optional hasScripts scriptsPackage
        ++ lib.optional hasEditable editablePackage;
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
    , editablePackageSources ? { }
    , extraPackages ? ps: [ ]
    }:
    let
      inherit (lib) elem hasAttr;

      pyProject = readTOML pyproject;

      # Automatically add dependencies with develop = true as editable packages, but only if path dependencies
      getEditableDeps = set: lib.mapAttrs
        (name: value: projectDir + "/${value.path}")
        (lib.filterAttrs (name: dep: dep.develop or false && hasAttr "path" dep) set);

      editablePackageSources' = (
        (getEditableDeps (pyProject.tool.poetry."dependencies" or { }))
        // (getEditableDeps (pyProject.tool.poetry."dev-dependencies" or { }))
        // editablePackageSources
      );

      poetryPython = self.mkPoetryPackages {
        inherit pyproject poetrylock overrides python pwd preferWheels pyProject;
        editablePackageSources = editablePackageSources';
      };

      inherit (poetryPython) poetryPackages;

      # Don't add editable sources to the environment since they will sometimes fail to build and are not useful in the development env
      editableAttrs = lib.attrNames editablePackageSources';
      envPkgs = builtins.filter (drv: ! lib.elem (drv.pname or drv.name or "") editableAttrs) poetryPackages;

    in
    poetryPython.python.withPackages (ps: envPkgs ++ (extraPackages ps));

  /* Creates a Python application from pyproject.toml and poetry.lock

    The result also contains a .dependencyEnv attribute which is a python
    environment of all dependencies and this apps modules. This is useful if
    you rely on dependencies to invoke your modules for deployment: e.g. this
    allows `gunicorn my-module:app`.
  */
  mkPoetryApplication =
    { projectDir ? null
    , src ? (
        # Assume that a project which is the result of a derivation is already adequately filtered
        if lib.isDerivation projectDir then projectDir else self.cleanPythonSources { src = projectDir; }
      )
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

      inputAttrs = mkInputAttrs { inherit py pyProject attrs; };

      app = py.pkgs.buildPythonPackage (
        passedAttrs // inputAttrs // {
          nativeBuildInputs = inputAttrs.nativeBuildInputs ++ [
            py.pkgs.removePathDependenciesHook
            py.pkgs.removeGitDependenciesHook
          ];
        } // {
          pname = moduleName pyProject.tool.poetry.name;
          version = pyProject.tool.poetry.version;

          inherit src;

          format = "pyproject";
          # Like buildPythonApplication, but without the toPythonModule part
          # Meaning this ends up looking like an application but it also
          # provides python modules
          namePrefix = "";

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

          # Extract position from explicitly passed attrs so meta.position won't point to poetry2nix internals
          pos = builtins.unsafeGetAttrPos (lib.elemAt (lib.attrNames attrs) 0) attrs;

          meta = lib.optionalAttrs (lib.hasAttr "description" pyProject.tool.poetry)
            {
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

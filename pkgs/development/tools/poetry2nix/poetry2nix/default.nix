{ pkgs ? import <nixpkgs> { }
, lib ? pkgs.lib
, poetry ? null
, poetryLib ? import ./lib.nix { inherit lib pkgs; stdenv = pkgs.stdenv; }
}:
let
  # Poetry2nix version
  version = "1.34.1";

  inherit (poetryLib) isCompatible readTOML normalizePackageName normalizePackageSet;

  # Map SPDX identifiers to license names
  spdxLicenses = lib.listToAttrs (lib.filter (pair: pair.name != null) (builtins.map (v: { name = if lib.hasAttr "spdxId" v then v.spdxId else null; value = v; }) (lib.attrValues lib.licenses)));
  # Get license by id falling back to input string
  getLicenseBySpdxId = spdxId: spdxLicenses.${spdxId} or spdxId;

  # Experimental withPlugins functionality
  toPluginAble = (import ./plugins.nix { inherit pkgs lib; }).toPluginAble;

  # List of known build systems that are passed through from nixpkgs unmodified
  knownBuildSystems = builtins.fromJSON (builtins.readFile ./known-build-systems.json);
  nixpkgsBuildSystems = lib.subtractLists [ "poetry" "poetry-core" ] knownBuildSystems;

  mkInputAttrs =
    { py
    , pyProject
    , attrs
    , includeBuildSystem ? true
    , groups ? [ ]
    , checkGroups ? [ "dev" ]
    }:
    let
      getInputs = attr: attrs.${attr} or [ ];

      # Get dependencies and filter out depending on interpreter version
      getDeps = depSet:
        let
          compat = isCompatible (poetryLib.getPythonVersion py);
          depAttrs = builtins.map (d: lib.toLower d) (builtins.attrNames depSet);
        in
        (
          builtins.map
            (
              dep:
              let
                pkg = py.pkgs."${normalizePackageName dep}";
                constraints = depSet.${dep}.python or "";
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
      propagatedBuildInputs = mkInput "propagatedBuildInputs" (
        (getDeps pyProject.tool.poetry."dependencies" or { })
        ++ (
          # >=poetry-1.2.0 dependency groups
          if pyProject.tool.poetry.group or { } != { }
          then lib.flatten (map (g: getDeps pyProject.tool.poetry.group.${g}.dependencies) groups)
          else [ ]
        )
      );
      nativeBuildInputs = mkInput "nativeBuildInputs" [ ];
      checkInputs = mkInput "checkInputs" (
        getDeps (pyProject.tool.poetry."dev-dependencies" or { })  # <poetry-1.2.0
        # >=poetry-1.2.0 dependency groups
        ++ lib.flatten (map (g: getDeps (pyProject.tool.poetry.group.${g}.dependencies or { })) checkGroups)
      );
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
    , pyProject ? readTOML pyproject
    , groups ? [ ]
    , checkGroups ? [ "dev" ]
    }:
    let
      /* The default list of poetry2nix override overlays */
      mkEvalPep508 = import ./pep508.nix {
        inherit lib poetryLib;
        inherit (python) stdenv;
      };
      getFunctorFn = fn: if builtins.typeOf fn == "set" then fn.__functor else fn;

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
        lib.listToAttrs (lib.mapAttrsToList (n: v: { name = normalizePackageName n; value = v; }) lockfiles);
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
          lockPkgs = builtins.listToAttrs (
            builtins.map
              (
                pkgMeta:
                let normalizedName = normalizePackageName pkgMeta.name; in
                {
                  name = normalizedName;
                  value = self.mkPoetryDep (
                    pkgMeta // {
                      inherit pwd preferWheels;
                      source = pkgMeta.source or null;
                      files = lockFiles.${normalizedName};
                      pythonPackages = self;

                      sourceSpec = (
                        (normalizePackageSet pyProject.tool.poetry.dependencies or { }).${normalizedName}
                          or (normalizePackageSet pyProject.tool.poetry.dev-dependencies or { }).${normalizedName}
                          or (normalizePackageSet pyProject.tool.poetry.group.dev.dependencies { }).${normalizedName} # Poetry 1.2.0+
                          or { }
                      );
                    }
                  );
                }
              )
              (lib.reverseList compatible)
          );
          buildSystems = builtins.listToAttrs (builtins.map (x: { name = x; value = super.${x}; }) nixpkgsBuildSystems);
        in
        lockPkgs // buildSystems // {
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
                    inherit lib python poetryLib evalPep508;
                  };

                  # # Use poetry-core from the poetry build (pep517/518 build-system)
                  poetry-core = poetryPkg.passthru.python.pkgs.poetry-core;
                  poetry = poetryPkg;

                  __toPluginAble = toPluginAble self;

                  inherit (hooks) pipBuildHook removePathDependenciesHook removeGitDependenciesHook poetry2nixFixupHook wheelUnpackHook;
                } // lib.optionalAttrs (! super ? setuptools-scm) {
                  # The canonical name is setuptools-scm
                  setuptools-scm = super.setuptools_scm;
                }
            )

            # Fix infinite recursion in a lot of packages because of checkInputs
            (self: super: lib.mapAttrs
              (name: value: (
                if lib.isDerivation value && lib.hasAttr "overridePythonAttrs" value
                then value.overridePythonAttrs (_: { doCheck = false; })
                else value
              ))
              super)

            # Null out any filtered packages, we don't want python.pkgs from nixpkgs
            (self: super: builtins.listToAttrs (builtins.map (x: { name = normalizePackageName x.name; value = null; }) incompatible))
            # Create poetry2nix layer
            baseOverlay

          ] ++ # User provided overrides
          (if builtins.typeOf overrides == "list" then overrides else [ overrides ])
        );
      packageOverrides = lib.foldr lib.composeExtensions (self: super: { }) overlays;
      py = python.override { inherit packageOverrides; self = py; };

      inputAttrs = mkInputAttrs { inherit py pyProject groups checkGroups; attrs = { }; includeBuildSystem = false; };

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
    , groups ? [ "dev" ]
    }:
    let
      inherit (lib) hasAttr;

      pyProject = readTOML pyproject;

      # Automatically add dependencies with develop = true as editable packages, but only if path dependencies
      getEditableDeps = set: lib.mapAttrs
        (name: value: projectDir + "/${value.path}")
        (lib.filterAttrs (name: dep: dep.develop or false && hasAttr "path" dep) set);

      excludedEditablePackageNames = builtins.filter
        (pkg: editablePackageSources."${pkg}" == null)
        (builtins.attrNames editablePackageSources);

      allEditablePackageSources = (
        (getEditableDeps (pyProject.tool.poetry."dependencies" or { }))
        // (getEditableDeps (pyProject.tool.poetry."dev-dependencies" or { }))
        // (
          # Poetry>=1.2.0
          if pyProject.tool.poetry.group or { } != { } then
            builtins.foldl' (acc: g: acc // getEditableDeps pyProject.tool.poetry.group.${g}.dependencies) { } groups
          else { }
        )
        // editablePackageSources
      );

      editablePackageSources' = builtins.removeAttrs
        allEditablePackageSources
        excludedEditablePackageNames;

      poetryPython = self.mkPoetryPackages {
        inherit pyproject poetrylock overrides python pwd preferWheels pyProject groups;
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
    , groups ? [ ]
    , checkGroups ? [ "dev" ]
    , ...
    }@attrs:
    let
      poetryPython = self.mkPoetryPackages {
        inherit pyproject poetrylock overrides python pwd preferWheels groups checkGroups;
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

      inputAttrs = mkInputAttrs { inherit py pyProject attrs groups checkGroups; };

      app = py.pkgs.buildPythonPackage (
        passedAttrs // inputAttrs // {
          nativeBuildInputs = inputAttrs.nativeBuildInputs ++ [
            py.pkgs.removePathDependenciesHook
            py.pkgs.removeGitDependenciesHook
          ];
        } // {
          pname = normalizePackageName pyProject.tool.poetry.name;
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
  defaultPoetryOverrides = self.mkDefaultPoetryOverrides (import ./overrides { inherit pkgs lib poetryLib; });

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

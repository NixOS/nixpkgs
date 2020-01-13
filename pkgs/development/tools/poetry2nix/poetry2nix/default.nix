{ pkgs ? import <nixpkgs> {}
, lib ? pkgs.lib
, poetry ? null
, poetryLib ? import ./lib.nix { inherit lib pkgs; }
}:

let
  inherit (poetryLib) isCompatible readTOML;

  # Poetry2nix version
  version = "1.1.0";

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

  #
  # Returns an attrset { python, poetryPackages } for the given lockfile
  #
  mkPoetryPython =
    { poetrylock
    , poetryPkg
    , overrides ? [ defaultPoetryOverrides ]
    , meta ? {}
    , python ? pkgs.python3
    , pwd ? null
    }@attrs: let
      lockData = readTOML poetrylock;
      lockFiles = lib.getAttrFromPath [ "metadata" "files" ] lockData;

      specialAttrs = [ "poetrylock" "overrides" ];
      passedAttrs = builtins.removeAttrs attrs specialAttrs;

      evalPep508 = mkEvalPep508 python;

      # Filter packages by their PEP508 markers
      partitions = let
        supportsPythonVersion = pkgMeta: if pkgMeta ? marker then (evalPep508 pkgMeta.marker) else true;
      in
        lib.partition supportsPythonVersion lockData.package;

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
            self: super: {
              mkPoetryDep = self.callPackage ./mk-poetry-dep.nix {
                inherit pkgs lib python poetryLib;
              };
              poetry = poetryPkg;
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
      };

  /* Returns a package with a python interpreter and all packages specified in the poetry.lock lock file.

     Example:
       poetry2nix.mkPoetryEnv { poetrylock = ./poetry.lock; python = python3; }
  */
  mkPoetryEnv =
    { poetrylock
    , overrides ? [ defaultPoetryOverrides ]
    , meta ? {}
    , pwd ? null
    , python ? pkgs.python3
    }:
      let
        poetryPkg = poetry.override { inherit python; };
        py = mkPoetryPython (
          {
            inherit poetryPkg poetrylock overrides meta python pwd;
          }
        );
      in
        py.python.withPackages (_: py.poetryPackages);

  /* Creates a Python application from pyproject.toml and poetry.lock */
  mkPoetryApplication =
    { src
    , pyproject
    , poetrylock
    , overrides ? [ defaultPoetryOverrides ]
    , meta ? {}
    , python ? pkgs.python3
    , pwd ? null
    , ...
    }@attrs: let
      poetryPkg = poetry.override { inherit python; };

      py = (
        mkPoetryPython {
          inherit poetryPkg poetrylock overrides meta python pwd;
        }
      ).python;

      pyProject = readTOML pyproject;

      specialAttrs = [ "pyproject" "poetrylock" "overrides" ];
      passedAttrs = builtins.removeAttrs attrs specialAttrs;

      getDeps = depAttr: let
        deps = pyProject.tool.poetry.${depAttr} or {};
        depAttrs = builtins.map (d: lib.toLower d) (builtins.attrNames deps);
      in
        builtins.map (dep: py.pkgs."${dep}") depAttrs;

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

          format = "pyproject";

          nativeBuildInputs = [ pkgs.yj ];
          buildInputs = mkInput "buildInputs" buildSystemPkgs;
          propagatedBuildInputs = mkInput "propagatedBuildInputs" (getDeps "dependencies") ++ ([ py.pkgs.setuptools ]);
          checkInputs = mkInput "checkInputs" (getDeps "dev-dependencies");

          passthru = {
            python = py;
          };

          postPatch = (passedAttrs.postPatch or "") + ''
            # Tell poetry not to resolve the path dependencies. Any version is
            # fine !
            yj -tj < pyproject.toml | python ${./pyproject-without-path.py} > pyproject.json
            yj -jt < pyproject.json > pyproject.toml
            rm pyproject.json
          '';

          meta = meta // {
            inherit (pyProject.tool.poetry) description homepage;
            license = getLicenseBySpdxId (pyProject.tool.poetry.license or "unknown");
          };

        }
      );

  /* Poetry2nix CLI used to supplement SHA-256 hashes for git dependencies  */
  cli = import ./cli.nix { inherit pkgs lib version; };

  /* Poetry2nix documentation  */
  doc = pkgs.stdenv.mkDerivation {
    pname = "poetry2nix-docs";
    inherit version;

    src = pkgs.runCommandNoCC "poetry2nix-docs-src" {} ''
      mkdir -p $out
      cp ${./default.nix} $out/default.nix
    '';

    buildInputs = [
      pkgs.nixdoc
    ];

    buildPhase = ''
      nixdoc --category poetry2nix --description "Poetry2nix functions" --file ./default.nix > poetry2nix.xml
    '';

    installPhase = ''
      mkdir -p $out
      cp poetry2nix.xml $out/
    '';

  };

in
{
  inherit mkPoetryEnv mkPoetryApplication cli doc;

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
}

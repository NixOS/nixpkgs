/* This file defines the composition for CRAN (R) packages. */

{ pkgs, overrides }:

let
  inherit (pkgs) R fetchurl stdenv lib xvfb_run utillinux;

  buildRPackage = import ./generic-builder.nix { inherit R xvfb_run utillinux ; };

  # Package template
  #
  # some packages, e.g. cncaGUI, require X running while installation,
  # so that we use xvfb-run if requireX is true.
  derive = lib.makeOverridable ({ name, version, sha256, depends ? [], skipTest ? false, requireX ? false, hydraPlatforms ? R.meta.hydraPlatforms  }: buildRPackage {
    name = "${name}-${version}";
    src = fetchurl {
      urls = [
        "mirror://cran/src/contrib/${name}_${version}.tar.gz"
        "mirror://cran/src/contrib/Archive/${name}/${name}_${version}.tar.gz"
      ];
      inherit sha256;
    };
    inherit skipTest requireX;
    propagatedBuildInputs = depends;
    nativeBuildInputs = depends;
    meta.homepage = "http://cran.r-project.org/web/packages/${name}/";
    meta.hydraPlatforms = hydraPlatforms;
  });

  # Overrides package definitions with nativeBuildInputs.
  # For example,
  #
  # overrideNativeBuildInputs {
  #   foo = [ pkgs.bar ]
  # } old
  #
  # results in
  #
  # {
  #   foo = old.foo.overrideDerivation (attrs: {
  #     nativeBuildInputs = attrs.nativeBuildInputs ++ [ pkgs.bar ];
  #   });
  # }
  overrideNativeBuildInputs = overrides: old:
    let
      attrNames = builtins.attrNames overrides;
      nameValuePairs = map (name: rec {
        inherit name;
        nativeBuildInputs = builtins.getAttr name overrides;
        value = (builtins.getAttr name old).overrideDerivation (attrs: {
          nativeBuildInputs = attrs.nativeBuildInputs ++ nativeBuildInputs;
        });
      }) attrNames;
    in
      builtins.listToAttrs nameValuePairs;

  # Overrides package definitions with buildInputs.
  # For example,
  #
  # overrideBuildInputs {
  #   foo = [ pkgs.bar ]
  # } old
  #
  # results in
  #
  # {
  #   foo = old.foo.overrideDerivation (attrs: {
  #     buildInputs = attrs.buildInputs ++ [ pkgs.bar ];
  #   });
  # }
  overrideBuildInputs = overrides: old:
    let
      attrNames = builtins.attrNames overrides;
      nameValuePairs = map (name: rec {
        inherit name;
        buildInputs = builtins.getAttr name overrides;
        value = (builtins.getAttr name old).overrideDerivation (attrs: {
          buildInputs = attrs.buildInputs ++ buildInputs;
        });
      }) attrNames;
    in
      builtins.listToAttrs nameValuePairs;

  # Overrides package definition requiring X running to install.
  # For example,
  #
  # overrideRequireX [
  #   "foo"
  # ] old
  #
  # results in
  #
  # {
  #   foo = old.foo.override {
  #     requireX = true;
  #   };
  # }
  overrideRequireX = packageNames: old:
    let
      nameValuePairs = map (name: {
        inherit name;
        value = (builtins.getAttr name old).override {
          requireX = true;
        };
      }) packageNames;
    in
      builtins.listToAttrs nameValuePairs;

  # Overrides package definition to skip tests.
  # For example,
  #
  # overrideSkipTests [
  #   "foo"
  # ] old
  #
  # results in
  #
  # {
  #   foo = old.foo.override {
  #     skipTest = true;
  #   };
  # }
  overrideSkipTests = packageNames: old:
    let
      nameValuePairs = map (name: {
        inherit name;
        value = (builtins.getAttr name old).override {
          skipTest = true;
        };
      }) packageNames;
    in
      builtins.listToAttrs nameValuePairs;

  packagesWithNativeBuildInputs = import ./packages-with-native-build-inputs.nix pkgs;
  packagesWithBuildInputs = import ./packages-with-build-inputs.nix pkgs;
  packagesRequireingX = import ./packages-requireing-x.nix;
  packagesToSkipTests = import ./packages-to-skip-tests.nix;

  defaultOverrides = old: new:
    let old0 = old; in
    let
      old1 = old0 // (overrideRequireX packagesRequireingX old0);
      old2 = old1 // (overrideSkipTests packagesToSkipTests old1);
      old3 = old2 // (overrideNativeBuildInputs packagesWithNativeBuildInputs old2);
      old4 = old3 // (overrideBuildInputs packagesWithBuildInputs old3);
      old = old4;
    in old // (import ./default-overrides.nix stdenv pkgs old new);


  # Recursive override pattern.
  # `_self` is a collection of packages;
  # `self` is `_self` with overridden packages;
  # packages in `_self` may depends on overridden packages.
  overridden = (defaultOverrides _self self) // overrides;

  maskedPackages = import ./masked-packages.nix;
  masked = removeAttrs overridden maskedPackages;

  self = masked;
  _self = import ./sources.nix { inherit self derive; };
in
  self

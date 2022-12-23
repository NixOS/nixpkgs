{ pkgs
, lib
, stdenv
, newScope
, julia
}:

with lib;

makeScope newScope (self:
  let
    callPackage = self.callPackage;

    buildJuliaPackage = callPackage ../development/compilers/julia/build-julia-package.nix {
      inherit lib stdenv;
      inherit julia;
      inherit computeRequiredJuliaPackages;
    };

    # Given a list of required Julia package derivations, get a list of
    # ALL required Julia packages needed for the ones specified to run.
    computeRequiredJuliaPackages = with lib; packages:
      let
        hasJuliaPackage = drv: drv ? isJuliaPackage;
        dependencies = packages':
          unique (flatten (catAttrs "requiredJuliaPackages" packages')
                  ++ (foldr (p: a: a ++ (dependencies p.requiredJuliaPackages)) [] (filter hasJuliaPackage  packages')));
      in unique packages ++ (dependencies packages);

    # The pname must correspond to the name 'PkgName' of the package
    # as used in the Julia command "using PkgName".
    juliaPkgsList = callPackage ../development/julia-modules {
      inherit juliaPkgs;
    };

    # Build the attribute set of the Julia packages from the packages definitions.
    # The package attribute name is set equal to the pname.
    juliaPackagesFromList = pkgsList:
      lib.foldr (p: a: a // { ${p.pname} = buildJuliaPackage p; }) {} pkgsList;

    juliaPkgs = juliaPackagesFromList juliaPkgsList;

  in {

    inherit callPackage buildJuliaPackage computeRequiredJuliaPackages;

    pkgs = juliaPkgs // { inherit buildJuliaPackage computeRequiredJuliaPackages juliaPackagesFromList; };

  })

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
      inherit computeRequiredJuliaPackages computeJuliaDepotPath computeJuliaLoadPath computeJuliaArtifacts;
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

    computeJuliaDepotPath = jpkgs: lib.concatMapStringsSep ":" (p: p + "/shared/julia/${p.packageCollection}") jpkgs;
    computeJuliaLoadPath = jpkgs: lib.concatMapStringsSep ":" (p: p + "/share/julia/${p.packageCollection}/packages") jpkgs;
    computeJuliaArtifacts = jpkgs: lib.filter (p: p ? isJuliaArtifact && p.isJuliaArtifact == true) jpkgs;

    # The pname must correspond to the name 'PkgName' of the package
    # as used in the Julia command "using PkgName".
    juliaPkgsList = callPackage ../development/julia-modules {
      inherit juliaPkgs pkgs lib;
      inherit computeRequiredJuliaPackages computeJuliaDepotPath computeJuliaLoadPath computeJuliaArtifacts;
    };

    # Build the attribute set of the Julia packages from the packages definitions.
    # The package attribute name is set equal to the pname.
    juliaPackagesFromList = pkgsList:
      lib.foldr (p: a: a // { ${p.pname} = buildJuliaPackage p; }) {} pkgsList;

    juliaPkgs = juliaPackagesFromList juliaPkgsList;

  in {

    inherit callPackage buildJuliaPackage computeRequiredJuliaPackages;

    pkgs = juliaPkgs // {
      inherit buildJuliaPackage computeRequiredJuliaPackages;
      inherit juliaPackagesFromList computeJuliaDepotPath;
      inherit computeJuliaLoadPath computeJuliaArtifacts;
    };

  })

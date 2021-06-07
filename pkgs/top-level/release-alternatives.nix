{ pkgsFun ? import ../..
, lib ? import ../../lib
, supportedSystems ? ["x86_64-linux"]
, allowUnfree ? false }:

let

  # called BLAS here, but also tests LAPACK
  blasUsers = [
    # "julia_07" "julia_10" "julia_11" "julia_13" "octave" "octaveFull"
    "fflas-ffpack" "linbox" "R" "ipopt" "hpl" "rspamd" "octopus"
    "sundials" "superlu" "suitesparse_5_3" "suitesparse_4_4"
    "suitesparse_4_2" "scs" "scalapack" "petsc" "cholmod-extra"
    "arpack" "qrupdate" "libcint" "iml" "globalarrays" "arrayfire" "armadillo"
    "xfitter" "lammps" "plink-ng" "quantum-espresso" "siesta"
    "siesta-mpi" "shogun" "calculix" "csdp" "getdp" "giac" "gmsh" "jags"
    "lammps" "lammps-mpi"

    # requires openblas
    # "caffe" "mxnet" "flint" "sage" "sageWithDoc"

    # broken
    # "gnss-sdr" "octave-jit" "openmodelica" "torch"

    # subpackages
    ["pythonPackages" "numpy"] ["pythonPackages" "prox-tv"] ["pythonPackages" "scs"]
    ["pythonPackages" "pysparse"] ["pythonPackages" "cvxopt"]
    # ["pythonPackages" "fenics"]
    ["rPackages" "slfm"] ["rPackages" "SamplerCompare"]
    # ["rPackages" "EMCluster"]
    # ["ocamlPackages" "lacaml"]
    # ["ocamlPackages" "owl"]
    ["haskellPackages" "bindings-levmar"]
  ] ++ lib.optionals allowUnfree [ "magma" ];
  blas64Users = [
    "rspamd" "suitesparse_5_3" "suitesparse_4_4"
    "suitesparse_4_2" "petsc" "cholmod-extra"
    "arpack" "qrupdate" "iml" "globalarrays" "arrayfire"
    "xfitter" "lammps" "plink-ng" "quantum-espresso"
    "calculix" "csdp" "getdp" "jags"
    "lammps" "lammps-mpi"
    # ["ocamlPackages" "lacaml"]
    ["haskellPackages" "bindings-levmar"]
  ] ++ lib.optionals allowUnfree [ "magma" ];
  blasProviders = system: [ "openblasCompat" "lapack-reference" "openblas" ]
    ++ lib.optionals (allowUnfree && system.isx86) ["mkl" "mkl64"];

  blas64Providers = [ "mkl64" "openblas"];

  mapListToAttrs = xs: f: builtins.listToAttrs (map (name: {
    name = if builtins.isList name
           then builtins.elemAt name (builtins.length name - 1)
           else name;
    value = f name;
  }) xs);

in

{
  blas = mapListToAttrs supportedSystems (system': let system = lib.systems.elaborate { system = system'; };
    in mapListToAttrs (blasProviders system) (provider: let
      isILP64 = builtins.elem provider (["mkl64"] ++ lib.optional system.is64bit "openblas");
      pkgs = pkgsFun {
        config = { inherit allowUnfree; };
        system = system';
        overlays = [(self: super: {
          lapack = super.lapack.override {
            lapackProvider = if provider == "mkl64"
                             then super.mkl
                             else builtins.getAttr provider super;
            inherit isILP64;
          };
          blas = super.blas.override {
            blasProvider = if provider == "mkl64"
                           then super.mkl
                           else builtins.getAttr provider super;
            inherit isILP64;
          };
        })];
      };
    in mapListToAttrs (if builtins.elem provider blas64Providers
                       then blas64Users else blasUsers)
                      (attr: if builtins.isList attr
                             then lib.getAttrFromPath attr pkgs
                             else builtins.getAttr attr pkgs)

        // { recurseForDerivations = true; })
      // { recurseForDerivations = true; })
    // { recurseForDerivations = true; };
  recurseForDerivations = true;
}

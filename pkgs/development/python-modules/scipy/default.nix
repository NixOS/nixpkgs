{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, fetchurl
, writeText
, python
, pythonOlder
, buildPythonPackage
, cython
, gfortran
, meson-python
, pkg-config
, pythran
, wheel
, setuptools
, hypothesis
, pytestCheckHook
, pytest_7
, pytest-xdist
, numpy
, pybind11
, pooch
, libxcrypt
, xsimd
, blas
, lapack
}:

let
  pname = "scipy";
  # DON'T UPDATE THESE ATTRIBUTES MANUALLY - USE:
  #
  #     nix-shell maintainers/scripts/update.nix --argstr package python3.pkgs.scipy
  #
  # The update script uses sed regexes to replace them with the updated hashes.
  version = "1.12.0";
  srcHash = "sha256-PuiyYTgSegDTV9Kae5N68FOXT1jyJrNv9p2aFP70Z20=";
  datasetsHashes = {
    ascent = "1qjp35ncrniq9rhzb14icwwykqg2208hcssznn3hz27w39615kh3";
    ecg = "1bwbjp43b7znnwha5hv6wiz3g0bhwrpqpi75s12zidxrbwvd62pj";
    face = "11i8x29h80y7hhyqhil1fg8mxag5f827g33lhnsf44qk116hp2wx";
  };
  datasets = lib.mapAttrs (
    d: hash: fetchurl {
      url = "https://raw.githubusercontent.com/scipy/dataset-${d}/main/${d}.dat";
      sha256 = hash;
    }
  ) datasetsHashes;
  # Additional cross compilation related properties that scipy reads in scipy/meson.build
  crossFileScipy = writeText "cross-file-scipy.conf" ''
    [properties]
    numpy-include-dir = '${numpy}/${python.sitePackages}/numpy/core/include'
    pythran-include-dir = '${pythran}/${python.sitePackages}/pythran'
    host-python-path = '${python.interpreter}'
    host-python-version = '${python.pythonVersion}'
  '';
in buildPythonPackage {
  inherit pname version;
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "scipy";
    repo = pname;
    rev = "v${version}";
    hash = srcHash;
    fetchSubmodules = true;
  };

  patches = [
    # Helps with cross compilation, see https://github.com/scipy/scipy/pull/18167
    (fetchpatch {
      url = "https://github.com/scipy/scipy/commit/dd50ac9d98dbb70625333a23e3a90e493228e3be.patch";
      hash = "sha256-Vf6/hhwu6X5s8KWhq8bUZKtSkdVu/GtEpGtj8Olxe7s=";
      excludes = [
        "doc/source/dev/contributor/meson_advanced.rst"
      ];
    })
    (fetchpatch {
      name = "openblas-0.3.26-compat.patch";
      url = "https://github.com/scipy/scipy/commit/8c96a1f742335bca283aae418763aaba62c03378.patch";
      hash = "sha256-SGoYDxwSAkr6D5/XEqHLerF4e4nmmI+PX+z+3taWAps=";
    })
  ];

  # Upstream complicated numpy version pinning is causing issues in the
  # configurePhase, so we pass on it.
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'numpy==' 'numpy>=' \
  '';

  nativeBuildInputs = [
    cython
    gfortran
    meson-python
    pythran
    pkg-config
    wheel
    setuptools
  ];

  buildInputs = [
    blas
    lapack
    pybind11
    pooch
    xsimd
  ] ++ lib.optionals (pythonOlder "3.9") [
    libxcrypt
  ];

  propagatedBuildInputs = [ numpy ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    hypothesis
    # Failed: DID NOT WARN. No warnings of type (<class 'DeprecationWarning'>, <class 'PendingDeprecationWarning'>, <class 'FutureWarning'>) were emitted.
    (pytestCheckHook.override { pytest = pytest_7; })
    pytest-xdist
  ];

  # The following tests are broken on aarch64-darwin with newer compilers and library versions.
  # See https://github.com/scipy/scipy/issues/18308
  disabledTests = lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
    "test_a_b_neg_int_after_euler_hypergeometric_transformation"
    "test_dst4_definition_ortho"
    "test_load_mat4_le"
    "hyp2f1_test_case47"
    "hyp2f1_test_case3"
    "test_uint64_max"
  ];

  doCheck = !(stdenv.isx86_64 && stdenv.isDarwin);

  preConfigure = ''
    # Helps parallelization a bit
    export NPY_NUM_BUILD_JOBS=$NIX_BUILD_CORES
    # We download manually the datasets and this variable tells the pooch
    # library where these files are cached. See also:
    # https://github.com/scipy/scipy/pull/18518#issuecomment-1562350648 And at:
    # https://github.com/scipy/scipy/pull/17965#issuecomment-1560759962
    export XDG_CACHE_HOME=$PWD; export HOME=$(mktemp -d); mkdir scipy-data
  '' + (lib.concatStringsSep "\n" (lib.mapAttrsToList (d: dpath:
    # Actually copy the datasets
    "cp ${dpath} scipy-data/${d}.dat"
  ) datasets));

  mesonFlags = [
    "-Dblas=${blas.pname}"
    "-Dlapack=${lapack.pname}"
    # We always run what's necessary for cross compilation, which is passing to
    # meson the proper cross compilation related arguments. See also:
    # https://docs.scipy.org/doc/scipy/building/cross_compilation.html
    "--cross-file=${crossFileScipy}"
  ];

  # disable stackprotector on aarch64-darwin for now
  #
  # build error:
  #
  # /private/tmp/nix-build-python3.9-scipy-1.6.3.drv-0/ccDEsw5U.s:109:15: error: index must be an integer in range [-256, 255].
  #
  #         ldr     x0, [x0, ___stack_chk_guard];momd
  #
  hardeningDisable = lib.optionals (stdenv.isAarch64 && stdenv.isDarwin) [ "stackprotector" ];

  preCheck = ''
    export OMP_NUM_THREADS=$(( $NIX_BUILD_CORES / 4 ))
    cd $out
  '';

  requiredSystemFeatures = [ "big-parallel" ]; # the tests need lots of CPU time

  passthru = {
    inherit blas;
    updateScript = [
      ./update.sh
      # Pass it this file name as argument
      (builtins.unsafeGetAttrPos "pname" python.pkgs.scipy).file
    ]
    # Pass it the names of the datasets to update their hashes
    ++ (builtins.attrNames datasetsHashes)
    ;
  };

  SCIPY_USE_G77_ABI_WRAPPER = 1;

  meta = with lib; {
    changelog = "https://github.com/scipy/scipy/releases/tag/v${version}";
    description = "SciPy (pronounced 'Sigh Pie') is open-source software for mathematics, science, and engineering";
    downloadPage = "https://github.com/scipy/scipy";
    homepage = "https://www.scipy.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fridh doronbehar ];
  };
}

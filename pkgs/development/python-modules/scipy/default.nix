{
  lib,
  stdenv,
  fetchurl,
  writeTextFile,
  python,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  cython,
  gfortran,
  meson-python,
  nukeReferences,
  pythran,
  pkg-config,
  setuptools,
  xcbuild,

  # buildInputs
  # Upstream has support for using Darwin's Accelerate package. However this
  # requires a Darwin user to work on a nice way to do that via an override.
  # See:
  # https://github.com/scipy/scipy/blob/v1.14.0/scipy/meson.build#L194-L211
  blas,
  lapack,
  pybind11,
  pooch,
  xsimd,
  boost189,
  qhull,

  # dependencies
  numpy,

  # tests
  hypothesis,
  pytestCheckHook,
  pytest-xdist,

  # Reverse dependency
  sage,
}:

buildPythonPackage (finalAttrs: {
  pname = "scipy";
  version = "1.17.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scipy";
    repo = "scipy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bDcM/RGfce/ZTYpTBNpKmX/7rXDqQs7rYkAmeXtzkZk=";
    fetchSubmodules = true;
  };

  patches = [
    # Helps with cross compilation, see https://github.com/scipy/scipy/pull/18167
    (fetchpatch {
      url = "https://github.com/scipy/scipy/commit/dd50ac9d98dbb70625333a23e3a90e493228e3be.patch";
      hash = "sha256-Vf6/hhwu6X5s8KWhq8bUZKtSkdVu/GtEpGtj8Olxe7s=";
      excludes = [ "doc/source/dev/contributor/meson_advanced.rst" ];
    })
  ];
  # A NOTE regarding the Numpy version relaxing: Both Numpy versions 1.x &
  # 2.x are supported. However upstream wants to always build with Numpy 2,
  # and with it to still be able to run with a Numpy 1 or 2. We insist to
  # perform this substitution even though python3.pkgs.numpy is of version 2
  # nowadays, because our ecosystem unfortunately doesn't allow easily
  # separating runtime and build-system dependencies. See also:
  #
  # https://discourse.nixos.org/t/several-comments-about-priorities-and-new-policies-in-the-python-ecosystem/51790
  #
  # Being able to build (& run) with Numpy 1 helps for python environments
  # that override globally the `numpy` attribute to point to `numpy_1`.
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "numpy>=2.0.0,<2.7" numpy
  '';

  build-system = [
    cython
    gfortran
    meson-python
    nukeReferences
    pythran
    pkg-config
    setuptools
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Minimal version required according to:
    # https://github.com/scipy/scipy/blob/v1.16.0/scipy/meson.build#L238-L244
    (xcbuild.override {
      sdkVer = "13.3";
    })
  ];

  buildInputs = [
    blas
    lapack
    pybind11
    pooch
    xsimd
    boost189
    qhull
  ];

  dependencies = [ numpy ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
    pytest-xdist
  ];

  disabledTests =
    lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
      # The following tests are broken on aarch64-darwin with newer compilers and library versions.
      # See https://github.com/scipy/scipy/issues/18308
      "test_a_b_neg_int_after_euler_hypergeometric_transformation"
      "test_dst4_definition_ortho"
      "test_load_mat4_le"
      "hyp2f1_test_case47"
      "hyp2f1_test_case3"
      "test_uint64_max"
      "test_large_m4" # https://github.com/scipy/scipy/issues/22466
      "test_spiral_cleanup"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isPower64 && stdenv.hostPlatform.isBigEndian) [
      # https://github.com/scipy/scipy/issues/24090
      "test_cython_api"
      "test_distance_transform_cdt05"
      "test_eval_chebyt_gh20129"
      "test_hyp0f1"
      "test_hyp0f1_gh5764"
      "test_simple_det_shapes_real_complex"
    ]
    ++ lib.optionals (python.isPy311) [
      # https://github.com/scipy/scipy/issues/22789 Observed only with Python 3.11
      "test_funcs"
    ];

  doCheck = !(stdenv.hostPlatform.isx86_64 && stdenv.hostPlatform.isDarwin);

  preConfigure = ''
    # Helps parallelization a bit
    export NPY_NUM_BUILD_JOBS=$NIX_BUILD_CORES
    # We download manually the datasets and this variable tells the pooch
    # library where these files are cached. See also:
    # https://github.com/scipy/scipy/pull/18518#issuecomment-1562350648 And at:
    # https://github.com/scipy/scipy/pull/17965#issuecomment-1560759962
    export XDG_CACHE_HOME=$PWD; export HOME=$(mktemp -d); mkdir scipy-data
  ''
  + (lib.concatStringsSep "\n" (
    lib.mapAttrsToList (
      d: dpath:
      # Actually copy the datasets
      "cp ${dpath} scipy-data/${d}.dat"
    ) finalAttrs.finalPackage.passthru.datasets
  ));

  mesonFlags = [
    "-Dblas=${blas.pname}"
    "-Dlapack=${lapack.pname}"
    # We always run what's necessary for cross compilation, which is passing to
    # meson the proper cross compilation related arguments. See also:
    # https://docs.scipy.org/doc/scipy/building/cross_compilation.html
    "--cross-file=${finalAttrs.finalPackage.passthru.crossFile}"
    "-Duse-system-libraries=all"
  ];

  # disable stackprotector on aarch64-darwin for now
  #
  # build error:
  #
  # /private/tmp/nix-build-python3.9-scipy-1.6.3.drv-0/ccDEsw5U.s:109:15: error: index must be an integer in range [-256, 255].
  #
  #         ldr     x0, [x0, ___stack_chk_guard];momd
  #
  hardeningDisable = lib.optionals (stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isDarwin) [
    "stackprotector"
  ];

  # remove references to dev dependencies
  postInstall = ''
    nuke-refs $out/${python.sitePackages}/scipy/__config__.py
    rm $out/${python.sitePackages}/scipy/__pycache__/__config__.*.opt-1.pyc
  '';

  preCheck = ''
    export OMP_NUM_THREADS=$(( $NIX_BUILD_CORES / 4 ))
    if [ $OMP_NUM_THREADS -eq 0 ]; then
      export OMP_NUM_THREADS=1
    fi

    cd $out
  '';

  requiredSystemFeatures = [ "big-parallel" ]; # the tests need lots of CPU time

  passthru = {
    inherit blas;
    tests = {
      inherit sage;
    };
    # NOTE: Every once in a while, these hashes might need an update. Use:
    #
    #   nix build -Lf. --rebuild python3.pkgs.scipy.passthru.datasets
    #
    # To verify the hashes are correct.
    datasetsHashes = {
      ascent = "sha256-A84STBr8iA+HtV9rBhEQ4uHpOWeRhPVhTjjazGwZV+I=";
      ecg = "sha256-8grTNl+5t/hF0OXEi2/mcIE3fuRmw6Igt/afNciVi68=";
      face = "sha256-nYsLTQgTE+K0hXSMdwRy5ale0XOBRog9hMcDBJPoKIY=";
    };
    datasets = lib.mapAttrs (
      d: hash:
      fetchurl {
        url = "https://raw.githubusercontent.com/scipy/dataset-${d}/main/${d}.dat";
        inherit hash;
      }
    ) finalAttrs.finalPackage.passthru.datasetsHashes;
    # Additional cross compilation related properties that scipy reads in scipy/meson.build
    buildConfig = {
      properties = {
        numpy-include-dir = numpy.coreIncludeDir;
        pythran-include-dir = "${pythran}/${python.sitePackages}/pythran";
        host-python-path = python.interpreter;
        host-python-version = python.pythonVersion;
      };
    };
    crossFile = writeTextFile {
      name = "cross-file-scipy.conf";
      text = lib.generators.toINI {
        mkKeyValue = lib.generators.mkKeyValueDefault {
          mkValueString = v: "'${v}'";
        } " = ";
      } finalAttrs.finalPackage.passthru.buildConfig;
    };
  };

  env.SCIPY_USE_G77_ABI_WRAPPER = 1;

  meta = {
    changelog = "https://github.com/scipy/scipy/releases/tag/v${finalAttrs.version}";
    description = "SciPy (pronounced 'Sigh Pie') is open-source software for mathematics, science, and engineering";
    downloadPage = "https://github.com/scipy/scipy";
    homepage = "https://www.scipy.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
})

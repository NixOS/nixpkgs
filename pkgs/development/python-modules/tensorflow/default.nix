{
  stdenv,
  bazel_6,
  buildBazelPackage,
  lib,
  fetchFromGitHub,
  symlinkJoin,
  addDriverRunpath,
  fetchpatch,
  fetchzip,
  linkFarm,
  # Python deps
  buildPythonPackage,
  pythonAtLeast,
  pythonOlder,
  python,
  pythonRelaxDepsHook,
  # Python libraries
  numpy,
  tensorboard,
  abseil-cpp,
  absl-py,
  packaging,
  setuptools,
  wheel,
  keras-preprocessing,
  google-pasta,
  opt-einsum,
  astunparse,
  h5py,
  ml-dtypes,
  termcolor,
  grpcio,
  six,
  wrapt,
  protobuf-python,
  tensorflow-estimator-bin,
  dill,
  flatbuffers-python,
  portpicker,
  tblib,
  typing-extensions,
  distutils,
  charset-normalizer,
  markupsafe,
  psutil,
  # Common deps
  git,
  pybind11,
  which,
  binutils,
  glibcLocales,
  cython,
  perl,
  llvmPackages,
  pkg-config,
  ninja,
  lndir,
  writeShellScriptBin,
  writeText,
  # Common libraries
  jemalloc,
  mpi,
  gast,
  grpc,
  sqlite,
  boringssl,
  jsoncpp,
  nsync,
  curl,
  snappy,
  flatbuffers-core,
  icu,
  double-conversion,
  libpng,
  libjpeg_turbo,
  giflib,
  protobuf-core,
  hdf5,
  # Upstream by default includes cuda support since tensorflow 1.15. We could do
  # that in nix as well. It would make some things easier and less confusing, but
  # it would also make the default tensorflow package unfree. See
  # https://groups.google.com/a/tensorflow.org/forum/#!topic/developers/iRCt5m4qUz0
  config,
  cudaSupport ? config.cudaSupport,
  cudaPackages,
  cudaCapabilities ? cudaPackages.cudaFlags.cudaCapabilities,
  mklSupport ? false,
  mkl,
  tensorboardSupport ? true,
  # XLA without CUDA is broken
  xlaSupport ? cudaSupport,
  sse42Support ? stdenv.hostPlatform.sse4_2Support,
  avx2Support ? stdenv.hostPlatform.avx2Support,
  fmaSupport ? stdenv.hostPlatform.fmaSupport,
  # Darwin deps
  Foundation,
  Security,
  cctools,
  xcbuild,
}:

let
  originalStdenv = stdenv;
in
let
  # Tensorflow looks at many toolchain-related variables which may diverge.
  #
  # Toolchain for cuda-enabled builds.
  # We want to achieve two things:
  # 1. NVCC should use a compatible back-end (e.g. gcc11 for cuda11)
  # 2. Normal C++ files should be compiled with the same toolchain,
  #    to avoid potential weird dynamic linkage errors at runtime.
  #    This may not be necessary though
  #
  # Toolchain for Darwin:
  # clang 7 fails to emit a symbol for
  # __ZN4llvm11SmallPtrSetIPKNS_10AllocaInstELj8EED1Ev in any of the
  # translation units, so the build fails at link time
  stdenv =
    if cudaSupport then
      cudaPackages.backendStdenv
    else if originalStdenv.hostPlatform.isDarwin then
      llvmPackages.stdenv
    else
      originalStdenv;
  inherit (cudaPackages) cudatoolkit nccl;
  # use compatible cuDNN (https://www.tensorflow.org/install/source#gpu)
  # cudaPackages.cudnn led to this:
  # https://github.com/tensorflow/tensorflow/issues/60398
  cudnnAttribute = "cudnn_8_7";
  cudnnMerged = symlinkJoin {
    name = "cudnn-merged";
    paths = [
      (lib.getDev cudaPackages.${cudnnAttribute})
      (lib.getLib cudaPackages.${cudnnAttribute})
    ];
  };
  gentoo-patches = fetchzip {
    url = "https://dev.gentoo.org/~perfinion/patches/tensorflow-patches-2.12.0.tar.bz2";
    hash = "sha256-SCRX/5/zML7LmKEPJkcM5Tebez9vv/gmE4xhT/jyqWs=";
  };
  protobuf-extra = linkFarm "protobuf-extra" [
    {
      name = "include";
      path = protobuf-core.src;
    }
  ];

  withTensorboard = (pythonOlder "3.6") || tensorboardSupport;

  cudaComponents = with cudaPackages; [
    (cuda_nvcc.__spliced.buildHost or cuda_nvcc)
    (cuda_nvprune.__spliced.buildHost or cuda_nvprune)
    cuda_cccl # block_load.cuh
    cuda_cudart # cuda.h
    cuda_cupti # cupti.h
    cuda_nvcc # See https://github.com/google/jax/issues/19811
    cuda_nvml_dev # nvml.h
    cuda_nvtx # nvToolsExt.h
    libcublas # cublas_api.h
    libcufft # cufft.h
    libcurand # curand.h
    libcusolver # cusolver_common.h
    libcusparse # cusparse.h
  ];

  cudatoolkitDevMerged = symlinkJoin {
    name = "cuda-${cudaPackages.cudaVersion}-dev-merged";
    paths = lib.concatMap (p: [
      (lib.getBin p)
      (lib.getDev p)
      (lib.getLib p)
      (lib.getOutput "static" p) # Makes for a very fat closure
    ]) cudaComponents;
  };

  # Tensorflow expects bintools at hard-coded paths, e.g. /usr/bin/ar
  # The only way to overcome that is to set GCC_HOST_COMPILER_PREFIX,
  # but that path must contain cc as well, so we merge them
  cudatoolkit_cc_joined = symlinkJoin {
    name = "${stdenv.cc.name}-merged";
    paths = [
      stdenv.cc
      binutils.bintools # for ar, dwp, nm, objcopy, objdump, strip
    ];
  };

  # Needed for _some_ system libraries, grep INCLUDEDIR.
  includes_joined = symlinkJoin {
    name = "tensorflow-deps-merged";
    paths = [ jsoncpp ];
  };

  tfFeature = x: if x then "1" else "0";

  version = "2.14.0";
  format = "setuptools";
  variant = lib.optionalString cudaSupport "-gpu";
  pname = "tensorflow${variant}";

  pythonEnv = python.withPackages (_: [
    # python deps needed during wheel build time (not runtime, see the buildPythonPackage part for that)
    # This list can likely be shortened, but each trial takes multiple hours so won't bother for now.
    absl-py
    astunparse
    dill
    distutils
    flatbuffers-python
    gast
    google-pasta
    grpcio
    h5py
    keras-preprocessing
    numpy
    opt-einsum
    packaging
    protobuf-python
    setuptools
    six
    tblib
    tensorboard
    tensorflow-estimator-bin
    termcolor
    typing-extensions
    wheel
    wrapt
  ]);

  python_major = lib.take 2 (lib.splitString "." python.version);
  python_dotted = lib.concatStringsSep "." python_major;
  python_underscored = lib.concatStringsSep "_" python_major;
  python_undotted = lib.concatStringsSep "" python_major;

  rules_cc_darwin_patched = stdenv.mkDerivation {
    name = "rules_cc-${pname}-${version}";

    src = _bazel-build.deps;

    prePatch = "pushd rules_cc";
    patches = [
      # https://github.com/bazelbuild/rules_cc/issues/122
      (fetchpatch {
        name = "tensorflow-rules_cc-libtool-path.patch";
        url = "https://github.com/bazelbuild/rules_cc/commit/8c427ab30bf213630dc3bce9d2e9a0e29d1787db.diff";
        hash = "sha256-C4v6HY5+jm0ACUZ58gBPVejCYCZfuzYKlHZ0m2qDHCk=";
      })

      # https://github.com/bazelbuild/rules_cc/pull/124
      (fetchpatch {
        name = "tensorflow-rules_cc-install_name_tool-path.patch";
        url = "https://github.com/bazelbuild/rules_cc/commit/156497dc89100db8a3f57b23c63724759d431d05.diff";
        hash = "sha256-NES1KeQmMiUJQVoV6dS4YGRxxkZEjOpFSCyOq9HZYO0=";
      })
    ];
    postPatch = "popd";

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mv rules_cc/ "$out"

      runHook postInstall
    '';
  };
  llvm-raw_darwin_patched = stdenv.mkDerivation {
    name = "llvm-raw-${pname}-${version}";

    src = _bazel-build.deps;

    prePatch = "pushd llvm-raw";
    patches = [
      # Fix a vendored config.h that requires the 10.13 SDK
      ./llvm_bazel_fix_macos_10_12_sdk.patch
    ];
    postPatch = ''
      touch {BUILD,WORKSPACE}
      popd
    '';

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mv llvm-raw/ "$out"

      runHook postInstall
    '';
  };

  python-x86_64-nix = stdenv.mkDerivation {
    name = "python-x86_64-${pname}-${version}";

    src = _bazel-build.deps;

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir $out
      cp python_x86_64-unknown-linux-gnu/BUILD.bazel $out
      substituteInPlace $out/BUILD.bazel \
        --replace-fail @version_long@ ${python_dotted} \
        --replace-fail @version_short@ ${python_undotted}
      cp python_x86_64-unknown-linux-gnu/WORKSPACE $out
      ${lndir}/bin/lndir ${pythonEnv} $out

      runHook postInstall
    '';
  };

  python-aarch64-nix = stdenv.mkDerivation {
    name = "python-aarch64-${pname}-${version}";

    src = _bazel-build.deps;

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir $out
      cp python_aarch64-unknown-linux-gnu/BUILD.bazel $out
      substituteInPlace $out/BUILD.bazel \
        --replace-fail @version_long@ ${python_dotted} \
        --replace-fail @version_short@ ${python_undotted}
      cp python_aarch64-unknown-linux-gnu/WORKSPACE $out
      ${lndir}/bin/lndir ${pythonEnv} $out

      runHook postInstall
    '';
  };

  # In order to keep the deps hash stable, we put everything that depends
  # on the Python version into overrides.
  # TODO: figure out whether we can create these overrides without building
  #  the deps tarball first, e.g. using our Nix-vendored packages and
  #  `rules_python`
  nccl_archive-fix = stdenv.mkDerivation {
    name = "nccl_archive-fix";
    src = _bazel-build.deps;
    dontConfigure = true;
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      mkdir $out
      cp -r nccl_archive/* $out
      pushd $out
      rm BUILD.bazel
      ln -s ${_bazel-build.src}/third_party/nccl/archive.BUILD BUILD.bazel
      popd
      runHook postInstall
    '';
  };

  eigen_archive-fix = stdenv.mkDerivation {
    name = "eigen_archive-fix";
    src = _bazel-build.deps;
    dontConfigure = true;
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      mkdir $out
      cp -r eigen_archive/* $out
      pushd $out
      rm BUILD.bazel
      ln -s ${_bazel-build.src}/third_party/eigen3/eigen_archive.BUILD \
        BUILD.bazel
      popd
      runHook postInstall
    '';
  };

  ml_dtypes-fix = stdenv.mkDerivation {
    name = "ml_dtypes-fix";
    src = _bazel-build.deps;
    dontConfigure = true;
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      mkdir $out
      cp -r ml_dtypes/* $out
      pushd $out
      rm BUILD.bazel
      ln -s ${_bazel-build.src}/third_party/py/ml_dtypes/ml_dtypes.BUILD \
        BUILD.bazel
      rm tests/BUILD.bazel
      ln -s ${_bazel-build.src}/third_party/py/ml_dtypes/ml_dtypes.tests.BUILD \
        tests/BUILD.bazel
      popd
      runHook postInstall
    '';
  };

  charset-normalizer-bazel = stdenv.mkDerivation {
    name = "${charset-normalizer.pname}-bazel-${charset-normalizer.version}";
    src = _bazel-build.deps;
    dontConfigure = true;
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      mkdir $out
      cp pypi_charset_normalizer/* $out
      mkdir $out/bin $out/site-packages
      ${lndir}/bin/lndir ${charset-normalizer}/bin $out/bin
      ${lndir}/bin/lndir \
        ${charset-normalizer}/lib/python${python_dotted}/site-packages \
        $out/site-packages
      runHook postInstall
    '';
  };

  numpy-bazel = stdenv.mkDerivation {
    name = "${numpy.pname}-bazel-${numpy.version}";
    src = _bazel-build.deps;
    dontConfigure = true;
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      mkdir $out
      cp pypi_numpy/WORKSPACE $out
      cp pypi_numpy/rules_python_wheel_entry_point_f2py.py $out
      cp pypi_numpy/BUILD.bazel $out
      mkdir $out/bin $out/site-packages
      ${lndir}/bin/lndir ${numpy}/bin $out/bin
      ${lndir}/bin/lndir ${numpy}/lib/python${python_dotted}/site-packages \
        $out/site-packages
      runHook postInstall
    '';
  };

  grpcio-bazel = stdenv.mkDerivation {
    name = "${grpcio.pname}-bazel-${grpcio.version}";
    src = _bazel-build.deps;
    dontConfigure = true;
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      mkdir $out
      cp pypi_grpcio/* $out
      mkdir $out/site-packages
      ${lndir}/bin/lndir ${grpcio}/lib/python${python_dotted}/site-packages \
        $out/site-packages
      runHook postInstall
    '';
  };

  h5py-bazel = stdenv.mkDerivation {
    name = "${h5py.pname}-bazel-${h5py.version}";
    src = _bazel-build.deps;
    dontConfigure = true;
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      mkdir $out
      cp pypi_h5py/* $out
      mkdir $out/site-packages
      ${lndir}/bin/lndir ${h5py}/lib/python${python_dotted}/site-packages \
        $out/site-packages
      runHook postInstall
    '';
  };

  markupsafe-bazel = stdenv.mkDerivation {
    name = "${markupsafe.pname}-bazel-${markupsafe.version}";
    src = _bazel-build.deps;
    dontConfigure = true;
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      mkdir $out
      cp pypi_markupsafe/* $out
      mkdir $out/site-packages
      ${lndir}/bin/lndir \
        ${markupsafe}/lib/python${python_dotted}/site-packages \
        $out/site-packages
      runHook postInstall
    '';
  };

  psutil-bazel = stdenv.mkDerivation {
    name = "${psutil.pname}-bazel-${psutil.version}";
    src = _bazel-build.deps;
    dontConfigure = true;
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      mkdir $out
      cp pypi_psutil/* $out
      mkdir $out/site-packages
      ${lndir}/bin/lndir \
        ${psutil}/lib/python${python_dotted}/site-packages \
        $out/site-packages
      runHook postInstall
    '';
  };

  pypi-bazel = stdenv.mkDerivation {
    name = "pypi-bazel";
    src = _bazel-build.deps;
    dontConfigure = true;
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      mkdir $out
      cp pypi/* $out
      substituteInPlace $out/requirements.bzl \
        --replace-fail @version_underscored@ ${python_underscored}
      runHook postInstall
    '';
  };

  python-bazel = stdenv.mkDerivation {
    name = "python-bazel";
    src = _bazel-build.deps;
    dontConfigure = true;
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      mkdir $out
      cp python/* $out
      runHook postInstall
    '';
  };

  python_version_repo-bazel = stdenv.mkDerivation {
    name = "python-bazel";
    src = _bazel-build.deps;
    dontConfigure = true;
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      mkdir $out
      cp python_version_repo/* $out
      substituteInPlace $out/py_version.bzl \
        --replace-fail @version_long@ ${python_dotted}
      runHook postInstall
    '';
  };

  # https://stackoverflow.com/questions/70301375/noinline-macro-conflict-between-glib-and-cuda
  cuda_gnu_wrapper_includes = stdenv.mkDerivation {
    name = "wrap-gnu-lib";
    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      mkdir $out
      for wrapping in regex memory string condition_variable
        do echo "#ifdef NIX_TF_WRAPPED
      #include_next <$wrapping>
      #else
      #define NIX_TF_WRAPPED 1
      #undef __noinline__
      #include_next <$wrapping>
      #define __noinline__ __attribute__((noinline))
      #undef NIX_TF_WRAPPED
      #endif" > $out/$wrapping
      done
      runHook postInstall
    '';
  };

  clang_lib = llvmPackages.libclang.lib;

  clang_major = builtins.elemAt (lib.splitString "." clang_lib.version) 0;

  cuda_wrappers = "${clang_lib}/lib/clang/${clang_major}/include/cuda_wrappers";

  clang_gnu_wrapper = writeShellScriptBin "clang" ''
    ${llvmPackages.clang}/bin/clang \
      -isystem ${cuda_gnu_wrapper_includes} \
      "$@"
  '';

  cuda_clang_wrapper = writeShellScriptBin "clang" ''
    ${llvmPackages.clang}/bin/clang \
      -isystem ${cuda_gnu_wrapper_includes} \
      -isystem ${cuda_wrappers} \
      "$@"
  '';

  switching_clang_wrapper = writeShellScriptBin "clang" ''
    if echo " $@ " | grep -q " -x \?cuda "
      then ${cuda_clang_wrapper}/bin/clang "$@"
      else ${clang_gnu_wrapper}/bin/clang "$@"
    fi
  '';

  wrapped_clang = if cudaSupport then switching_clang_wrapper else llvmPackages.clang;

  bazel-build =
    if stdenv.hostPlatform.isDarwin then
      _bazel-build-python.overrideAttrs (prev: {
        bazelFlags = prev.bazelFlags ++ [
          "--override_repository=rules_cc=${rules_cc_darwin_patched}"
          "--override_repository=llvm-raw=${llvm-raw_darwin_patched}"
        ];
        preBuild = ''
          export AR="${cctools}/bin/libtool"
        '';
      })
    else
      _bazel-build-python;

  _bazel-build-python =
    if (!stdenv.isDarwin) then
      _bazel-build.overrideAttrs (prev: {
        bazelFlags =
          prev.bazelFlags
          ++ [
            (
              if stdenv.isx86_64 then
                "--override_repository=python_x86_64-unknown-linux-gnu=${python-x86_64-nix}"
              else
                "--override_repository=python_aarch64-unknown-linux-gnu=${python-aarch64-nix}"
            )
            "--override_repository=pypi_charset_normalizer=${charset-normalizer-bazel}"
            "--override_repository=pypi_numpy=${numpy-bazel}"
            "--override_repository=pypi_grpcio=${grpcio-bazel}"
            "--override_repository=pypi_h5py=${h5py-bazel}"
            "--override_repository=pypi_markupsafe=${markupsafe-bazel}"
            "--override_repository=pypi=${pypi-bazel}"
            "--override_repository=python=${python-bazel}"
            "--override_repository=python_version_repo=${python_version_repo-bazel}"
          ]
          ++ lib.optionals stdenv.isAarch64 [
            "--override_repository=pypi_psutil=${psutil-bazel}"
          ]
          ++ lib.optionals cudaSupport [
            "--override_repository=nccl_archive=${nccl_archive-fix}"
            "--override_repository=eigen_archive=${eigen_archive-fix}"
            "--override_repository=ml_dtypes=${ml_dtypes-fix}"
          ];
      })
    else
      _bazel-build;

  regenerate-compressed = writeText "regenerate.py" ''
    from zlib import compress
    from base64 import b64encode
    with open("find_cuda_config.py", "r") as file:
      input_text = file.read()
    output_data = b64encode(compress(str.encode(input_text)))
    with open("find_cuda_config.py.gz.base64", "w") as file:
      file.write(output_data.decode("ASCII"))
  '';

  _bazel-build = buildBazelPackage.override { inherit stdenv; } {
    name = "${pname}-${version}";
    bazel = bazel_6;

    src = fetchFromGitHub {
      owner = "tensorflow";
      repo = "tensorflow";
      tag = "v${version}";
      hash = "sha256-OvYb1YkYT9xeUGz3yBRdgNd/0s4YNhXPlw7yOR7pxB0=";
    };

    # On update, it can be useful to steal the changes from gentoo
    # https://gitweb.gentoo.org/repo/gentoo.git/tree/sci-libs/tensorflow

    nativeBuildInputs =
      [
        pkg-config
        hdf5
        which
        pythonEnv
        cython
        perl
        protobuf-core
        protobuf-extra
        wrapped_clang
        lndir
      ]
      ++ lib.optional cudaSupport addDriverRunpath
      ++ lib.optional stdenv.isDarwin xcbuild
      ++ lib.optional (pythonAtLeast "3.12") ninja;

    buildInputs =
      [
        jemalloc
        mpi
        glibcLocales
        git

        # libs taken from system through the TF_SYS_LIBS mechanism
        abseil-cpp
        boringssl
        curl
        double-conversion
        flatbuffers-core
        giflib
        grpc
        # Necessary to fix the "`GLIBCXX_3.4.30' not found" error
        (icu.override { inherit stdenv; })
        jsoncpp
        libjpeg_turbo
        libpng
        (
          if stdenv.hostPlatform.isDarwin then
            pybind11
          else
            (pybind11.overridePythonAttrs (_: {
              inherit stdenv;
            }))
        )
        snappy
        sqlite
      ]
      ++ lib.optionals cudaSupport [
        cudatoolkit
        cudnnMerged
      ]
      ++ lib.optionals mklSupport [ mkl ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        Foundation
        Security
      ]
      ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ nsync ];

    # arbitrarily set to the current latest bazel version, overly careful
    TF_IGNORE_MAX_BAZEL_VERSION = true;

    LIBTOOL = lib.optionalString stdenv.hostPlatform.isDarwin "${cctools}/bin/libtool";

    # Take as many libraries from the system as possible. Keep in sync with
    # list of valid syslibs in
    # https://github.com/tensorflow/tensorflow/blob/master/third_party/systemlibs/syslibs_configure.bzl
    TF_SYSTEM_LIBS = lib.concatStringsSep "," (
      [
        "absl_py"
        "astor_archive"
        "astunparse_archive"
        "boringssl"
        "com_google_absl"
        # Not packaged in nixpkgs
        # "com_github_googleapis_googleapis"
        # "com_github_googlecloudplatform_google_cloud_cpp"
        "com_github_grpc_grpc"
        "com_google_protobuf"
        # Fails with the error: external/org_tensorflow/tensorflow/core/profiler/utils/tf_op_utils.cc:46:49: error: no matching function for call to 're2::RE2::FullMatch(absl::lts_2020_02_25::string_view&, re2::RE2&)'
        # "com_googlesource_code_re2"
        "curl"
        "cython"
        "dill_archive"
        "double_conversion"
        "flatbuffers"
        "functools32_archive"
        "gast_archive"
        "gif"
        "hwloc"
        "icu"
        "jsoncpp_git"
        "libjpeg_turbo"
        "nasm"
        "opt_einsum_archive"
        "org_sqlite"
        "pasta"
        "png"
        "pybind11"
        "six_archive"
        "snappy"
        "tblib_archive"
        "termcolor_archive"
        "typing_extensions_archive"
        "wrapt"
        "zlib"
      ]
      ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
        "nsync" # fails to build on darwin
      ]
    );

    INCLUDEDIR = "${includes_joined}/include";

    # This is needed for the Nix-provided protobuf dependency to work,
    # as otherwise the rule `link_proto_files` tries to create the links
    # to `/usr/include/...` which results in build failures.
    PROTOBUF_INCLUDE_PATH = "${protobuf-core}/include";

    PYTHON_BIN_PATH = pythonEnv.interpreter;

    TF_NEED_GCP = true;
    TF_NEED_HDFS = true;
    TF_ENABLE_XLA = tfFeature xlaSupport;
    TF_PYTHON_VERSION = python.pythonVersion;

    CC_OPT_FLAGS = " ";

    # https://github.com/tensorflow/tensorflow/issues/14454
    TF_NEED_MPI = tfFeature cudaSupport;

    TF_NEED_CUDA = tfFeature cudaSupport;
    TF_CUDA_PATHS = lib.optionalString cudaSupport "${cudatoolkitDevMerged},${cudnnMerged},${lib.getLib nccl}";
    TF_CUDA_COMPUTE_CAPABILITIES = lib.concatStringsSep "," cudaCapabilities;

    # Needed even when we override stdenv: e.g. for ar
    GCC_HOST_COMPILER_PREFIX = lib.optionalString cudaSupport "${cudatoolkit_cc_joined}/bin";
    GCC_HOST_COMPILER_PATH = lib.optionalString cudaSupport "${cudatoolkit_cc_joined}/bin/cc";

    patches =
      [
        "${gentoo-patches}/0002-systemlib-Latest-absl-LTS-has-split-cord-libs.patch"
        "${gentoo-patches}/0005-systemlib-Updates-for-Abseil-20220623-LTS.patch"
        "${gentoo-patches}/0007-systemlibs-Add-well_known_types_py_pb2-target.patch"
        # https://github.com/conda-forge/tensorflow-feedstock/pull/329/commits/0a63c5a962451b4da99a9948323d8b3ed462f461
        (fetchpatch {
          name = "fix-layout-proto-duplicate-loading.patch";
          url = "https://raw.githubusercontent.com/conda-forge/tensorflow-feedstock/0a63c5a962451b4da99a9948323d8b3ed462f461/recipe/patches/0001-Omit-linking-to-layout_proto_cc-if-protobuf-linkage-.patch";
          hash = "sha256-/7buV6DinKnrgfqbe7KKSh9rCebeQdXv2Uj+Xg/083w=";
        })
        (fetchpatch {
          name = "fix-clang16-build.patch";
          url = "https://github.com/tensorflow/tensorflow/commit/055b7147a436360110480ba1ef97f4216e1909d8.diff";
          hash = "sha256-3eLmKMjcbYrb/RnpEuCYj4iOK4iMs3IVy976ruKPmTk=";
        })
        (fetchpatch {
          url = "https://github.com/openxla/xla/commit/30c1666bf76616b6d6569a262a6cc705b3ce5f47.diff";
          name = "denormal-cstdint.patch";
          stripLen = 3;
          extraPrefix = "tensorflow/";
          decode = "sed 's<\"tsl/<\"tensorflow/tsl/<'";
          hash = "sha256-Dm3NoEvChdNolunLIDlyD1anwtUlbnfBT4GBj2w0caM=";
        })
        ./fix-syslib-references.patch
        ./pybind11-osx.patch
        ./com_google_absl_add_log.patch
        ./protobuf_python.patch
        ./pybind11_protobuf_python_runtime_dep.patch
        ./pybind11_protobuf_newer_version.patch
        # the implementation from upstream using realpath breaks in the sandbox
        ./compute-links.patch
        ./add-python-312.patch
      ]
      ++ lib.optionals (!stdenv.isDarwin) [
        # we override Python in the bazel build anyway, but we also need
        # a usable Python during deps fetching
        ./core-rules-python-use-nix.patch
      ]
      ++ lib.optionals (cudaSupport) [
        ./system_includes_cuda.patch
        ./fix-string-syntax.patch
      ];

    postPatch =
      ''
        # bazel 3.3 should work just as well as bazel 3.1
        rm -f .bazelversion
        patchShebangs .
        sed 's,@bash@,${stdenv.shell},g' < ${./compute-relative.sh} \
          > tensorflow/compute-relative.sh
        chmod +x tensorflow/compute-relative.sh
        ! test -e requirements_lock_3_12.txt
        cp requirements_lock_3_11.txt requirements_lock_3_12.txt
        substituteInPlace requirements_lock_*.txt \
      ''
      + lib.optionalString (stdenv.isx86_64) ''
        --replace-fail \
          "00258cbe3f5188629828363ae8ff78477ce976a6f63fb2bb5e90088396faa82e" \
          "5711c51e204dc52065f4a3327dca46e69636a0b76d3e98c2c28c4ccef9b04c52" \
        --replace-fail \
          "092fa155b945015754bdf988be47793c377b52b88d546e45c6a9f9579ac7f7b6" \
          "956f0b7cb465a65de1bd90d5a7475b4dc55089b25042fe0f6c870707e9aabb1d" \
        --replace-fail \
          "2313b124e475aa9017a9844bdc5eafb2d5abdda9d456af16fc4535408c7d6da6" \
          "d0fcf53df684fcc0154b1e61f6b4a8c4cf5f49d98a63511e3f30966feff39cd0" \
      ''
      + lib.optionalString (stdenv.isAarch64) ''
        --replace-fail \
          "0f80bf37f09e1caba6a8063e56e2b87fa335add314cf2b78ebf7cb45aa7e3d06" \
          "2f120d27051e4c59db2f267b71b833796770d3ea36ca712befa8c5fff5da6ebd" \
        --replace-fail \
          "20ec6fc4ad47d1b6e12deec5045ec3cd5402d9a1597f738263e98f490fe07056" \
          "0b84445fa94d59e6806c10266b977f92fa997db3585f125d6b751af02ff8b9fe" \
      ''
      + ''
        --replace-fail "grpcio==1.57.0" "grpcio==1.59.0" \
      ''
      + lib.optionalString (stdenv.isx86_64) ''
        --replace-fail \
          "0cbe9848fad08baf71de1a39e12d1b6310f1d5b2d0ea4de051058e6e1076852d" \
          "666dbfb6ec68962c033a450943ded891bed2d54e6755e35e5835d63f4f6931d5" \
        --replace-fail \
          "1b1766d6f397c18153d40015ddfc79ddb715cabadc04d2d228d4e5a8bc4ded1a" \
          "675d61ffbfa78604709862923189bad94014bef562cc35cf61d3a07bba02a7ed" \
        --replace-fail \
          "09b7847f7e83ca37c6e627682f145856de331049013853f344f37b0c9690e3df" \
          "ffa75af20b44f8dba823498024771d5ac50620e6915abac414251bd971b4529f" \
      ''
      + lib.optionalString (stdenv.isAarch64) ''
        --replace-fail \
          "01dd17cbb340bf0fc23981e52e1d18a9d4050792e8fb8363cecbf066a84b827d" \
          "9fad7dcb1aac3c7f0584a5a8133e3a43eeb2fe127f47e3632d43d677c66c102b" \
        --replace-fail \
          "06005a2ef6014e9956c09ba07654f9837d9e26696a0470e42beedadb78c11b07" \
          "7ab55401287bfec946ced39700c053796e7cc0e3acbef09993a9ad2adba6ca6e" \
      ''
      + ''
          --replace-fail "numpy==1.23.5" "numpy==1.26.4"
        cp ${./rules-python-newer-versions.patch} \
          tensorflow/rules-python-newer-versions.patch
      ''
      + lib.optionalString (!stdenv.isDarwin) ''
        sed \
          -e 's,@python@,${pythonEnv},g' \
          -e 's,@python_version@,${python.version},g' \
          < ${./rules-python-use-nix.patch} \
          > tensorflow/rules-python-use-nix.patch
      ''
      + lib.optionalString (!withTensorboard) ''
        # Tensorboard pulls in a bunch of dependencies, some of which may
        # include security vulnerabilities. So we make it optional.
        # https://github.com/tensorflow/tensorflow/issues/20280#issuecomment-400230560
        sed -i '/tensorboard ~=/d' tensorflow/tools/pip_package/setup.py
      ''
      + lib.optionalString (cudaSupport) ''
        substituteInPlace third_party/gpus/cuda_configure.bzl \
          --replace-fail "@cuda_wrapper_includes@" "${cuda_wrappers}"
        substituteInPlace tensorflow/tools/pip_package/BUILD \
          --replace-fail '"@ml_dtypes//:LICENSE",' ""
        pushd third_party/gpus
        ${python}/bin/python3 ${regenerate-compressed}
        popd
      '';

    # https://github.com/tensorflow/tensorflow/pull/39470
    env.NIX_CFLAGS_COMPILE = toString [ "-Wno-stringop-truncation" ];

    preConfigure =
      let
        opt_flags =
          [ ]
          ++ lib.optionals sse42Support [ "-msse4.2" ]
          ++ lib.optionals avx2Support [ "-mavx2" ]
          ++ lib.optionals fmaSupport [ "-mfma" ];
      in
      ''
        patchShebangs configure

        # dummy ldconfig
        mkdir dummy-ldconfig
        echo "#!${stdenv.shell}" > dummy-ldconfig/ldconfig
        chmod +x dummy-ldconfig/ldconfig
        export PATH="$PWD/dummy-ldconfig:$PATH"

        export PYTHONPATH="${pythonEnv}/lib/${pythonEnv.libPrefix}/site-packages"
        export PYTHON_LIB_PATH="$NIX_BUILD_TOP/site-packages"
        export CC_OPT_FLAGS="${lib.concatStringsSep " " opt_flags}"
        mkdir -p "$PYTHON_LIB_PATH"
      '';

    configurePhase = ''
      runHook preConfigure
      ./configure
      runHook postConfigure
    '';

    hardeningDisable =
      [
        "format"
      ]
      ++ lib.optionals (cudaSupport) [
        "zerocallusedregs"
      ];

    bazelBuildFlags = [
      "--config=opt" # optimize using the flags set in the configure phase
      "--cxxopt=-x"
      "--cxxopt=c++"
      "--host_cxxopt=-x"
      "--host_cxxopt=c++"

      # workaround for https://github.com/bazelbuild/bazel/issues/15359
      "--spawn_strategy=sandboxed"
    ] ++ lib.optionals (mklSupport) [ "--config=mkl" ];

    bazelTargets = [
      "//tensorflow/tools/pip_package:build_pip_package //tensorflow/tools/lib_package:libtensorflow"
    ];

    removeRulesCC = false;
    # Without this Bazel complaints about sandbox violations.
    dontAddBazelOpts = true;

    fetchAttrs = {
      preInstall = lib.optionalString (!stdenv.isDarwin) (
        ''
          pushd $bazelOut
          rm -rf external/*/*.whl
          find external -type f | grep "/__pycache__/[^/]*[.]pyc\?$" | xargs rm
          find external -type l | grep "/__pycache__/[^/]*[.]pyc\?$" | xargs rm
          find external -type d | grep "/__pycache__$" | xargs rmdir
          rm -rf external/pypi_charset_normalizer/bin
          rm -rf external/pypi_charset_normalizer/site-packages
          rm -rf external/pypi_numpy/bin
          rm -rf external/pypi_numpy/site-packages
          rm -f external/pypi_numpy/rules_python_wheel_entry_point_f2py3.py
          rm -f external/pypi_numpy/rules_python_wheel_entry_point_f2py${python_dotted}.py
          rm -rf external/pypi_grpcio/site-packages
          rm -rf external/pypi_h5py/site-packages
          rm -rf external/pypi_markupsafe/site-packages
        ''
        + lib.optionalString (stdenv.isAarch64) ''
          rm -rf external/pypi_psutil/site-packages
        ''
        + ''
          substituteInPlace external/pypi/requirements.bzl \
            --replace-fail ${python_underscored} @version_underscored@
          substituteInPlace external/python_version_repo/py_version.bzl \
            --replace-fail ${python_dotted} @version_long@
          sed -i 's/(\("[^(),]*"\), "\([^()]*\)==[^()]*")/(\1, "\2")/g' \
            external/pypi/requirements.bzl
          rm -rf external/python_*-unknown-linux-gnu/bin
          rm -rf external/python_*-unknown-linux-gnu/include
          rm -rf external/python_*-unknown-linux-gnu/lib
          rm -rf external/python_*-unknown-linux-gnu/nix-support
          rm -rf external/python_*-unknown-linux-gnu/python
          rm -rf external/python_*-unknown-linux-gnu/share
          substituteInPlace external/python_*-unknown-linux-gnu/BUILD.bazel \
            --replace-fail python${python_dotted} python@version_long@ \
            --replace-fail python${python_undotted} python@version_short@
          substituteInPlace external/rules_python/python/repositories.bzl \
            --replace-fail ${pythonEnv} @python@ \
            --replace-fail ${python.version} @python_version@
          popd
        ''
      );

      sha256 =
        {
          x86_64-linux =
            if cudaSupport then
              "sha256-Kf8V2526As9AF8J0t1MRPLl0YaUG3H5Dxe53UEsQd04="
            else
              "sha256-2irYKdPaDhSDVOrgPv7oQKHaiEv5UtSZnzXnoKkDKAk=";
          aarch64-linux =
            if cudaSupport then
              "sha256-EdN3zX8Cuc4zj33t2oJiAun3svQI0bER1QE7Qn6oUzs="
            else
              "sha256-KXSbqwZpN4Im32St0ADyIc4N5/SQfiQPDoLu9bXbckY=";
          # deps hashes can't be computed for the Darwin platforms as of
          # 2024-10-21 as the expressions don't evaluate due to
          # python3Packages.jaraco-path being broken on these platforms
          x86_64-darwin = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
          aarch64-darwin = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
        }
        .${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}");
    };

    buildAttrs = {
      outputs = [
        "out"
        "python"
      ];

      # need to rebuild schemas since we use a different flatbuffers version
      preBuild = ''
        (cd tensorflow/lite/schema;${flatbuffers-core}/bin/flatc --gen-object-api -c schema.fbs)
        (cd tensorflow/lite/schema;${flatbuffers-core}/bin/flatc --gen-object-api -c conversion_metadata.fbs)
        (cd tensorflow/lite/acceleration/configuration;${flatbuffers-core}/bin/flatc -o configuration.fbs --proto configuration.proto)
        sed -i s,tflite.proto,tflite,g tensorflow/lite/acceleration/configuration/configuration.fbs/configuration.fbs
        (cd tensorflow/lite/acceleration/configuration;${flatbuffers-core}/bin/flatc --gen-compare --gen-object-api -c configuration.fbs/configuration.fbs)
        cp -r tensorflow/lite/acceleration/configuration/configuration.fbs tensorflow/lite/experimental/acceleration/configuration
        (cd tensorflow/lite/experimental/acceleration/configuration;${flatbuffers-core}/bin/flatc -c configuration.fbs/configuration.fbs)
        (cd tensorflow/lite/delegates/gpu/cl;${flatbuffers-core}/bin/flatc -c compiled_program_cache.fbs)
        (cd tensorflow/lite/delegates/gpu/cl;${flatbuffers-core}/bin/flatc -I $NIX_BUILD_TOP/source -c serialization.fbs)
        (cd tensorflow/lite/delegates/gpu/common;${flatbuffers-core}/bin/flatc -I $NIX_BUILD_TOP/source -c gpu_model.fbs)
        (cd tensorflow/lite/delegates/gpu/common/task;${flatbuffers-core}/bin/flatc -c serialization_base.fbs)
        patchShebangs .
      '';

      installPhase = ''
        mkdir -p "$out"
        tar -xf bazel-bin/tensorflow/tools/lib_package/libtensorflow.tar.gz -C "$out"
        # Write pkgconfig file.
        mkdir "$out/lib/pkgconfig"
        cat > "$out/lib/pkgconfig/tensorflow.pc" << EOF
        Name: TensorFlow
        Version: ${version}
        Description: Library for computation using data flow graphs for scalable machine learning
        Requires:
        Libs: -L$out/lib -ltensorflow
        Cflags: -I$out/include/tensorflow
        EOF

        # build the source code, then copy it to $python (build_pip_package
        # actually builds a symlink farm so we must dereference them).
        bazel-bin/tensorflow/tools/pip_package/build_pip_package --src "$PWD/dist"
        cp -Lr "$PWD/dist" "$python"
      '';

      postFixup = lib.optionalString cudaSupport ''
        find $out -type f \( -name '*.so' -or -name '*.so.*' \) | while read lib; do
          addDriverRunpath "$lib"
        done
      '';

      requiredSystemFeatures = [ "big-parallel" ];
    };

    meta =
      {
        badPlatforms = lib.optionals cudaSupport lib.platforms.darwin;
        changelog = "https://github.com/tensorflow/tensorflow/releases/tag/v${version}";
        description = "Computation using data flow graphs for scalable machine learning";
        homepage = "http://tensorflow.org";
        license = lib.licenses.asl20;
        maintainers = with lib.maintainers; [
          abbradar
          gm6k
        ];
        platforms = with lib.platforms; linux ++ darwin;
        broken =
          !(xlaSupport -> cudaSupport)
          || !(cudaSupport -> builtins.hasAttr cudnnAttribute cudaPackages)
          || !(cudaSupport -> cudaPackages ? cudatoolkit);
      }
      // lib.optionalAttrs stdenv.hostPlatform.isDarwin {
        timeout = 86400; # 24 hours
        maxSilent = 14400; # 4h, double the default of 7200s
      };
  };
in
buildPythonPackage {
  inherit version pname;
  disabled = pythonOlder "3.9";

  src = bazel-build.python;

  patches = [
    ./remove-keras-dependency.patch
  ];

  # Adjust dependency requirements:
  # - Drop tensorflow-io dependency until we get it to build
  # - Relax flatbuffers and gast version requirements
  # - The purpose of python3Packages.libclang is not clear at the moment and we don't have it packaged yet
  # - keras and tensorlow-io-gcs-filesystem will be considered as optional for now.
  pythonRelaxDeps = [
    "flatbuffers"
    "gast"
    "protobuf"
  ];

  pythonRemoveDeps = [
    "tensorflow-io-gcs-filesystem"
    "libclang"
    "keras"
  ];

  # Upstream has a pip hack that results in bin/tensorboard being in both tensorflow
  # and the propagated input tensorboard, which causes environment collisions.
  # Another possibility would be to have tensorboard only in the buildInputs
  # https://github.com/tensorflow/tensorflow/blob/v1.7.1/tensorflow/tools/pip_package/setup.py#L79
  postInstall = ''
    rm $out/bin/tensorboard
  '';

  setupPyGlobalFlags = [ "--project_name ${pname}" ];

  # tensorflow/tools/pip_package/setup.py
  propagatedBuildInputs = [
    absl-py
    abseil-cpp
    astunparse
    distutils
    flatbuffers-python
    gast
    google-pasta
    grpcio
    h5py
    keras-preprocessing
    ml-dtypes
    numpy
    opt-einsum
    packaging
    protobuf-python
    six
    tensorflow-estimator-bin
    termcolor
    typing-extensions
    wrapt
  ] ++ lib.optionals withTensorboard [ tensorboard ];

  nativeBuildInputs = lib.optionals cudaSupport [ addDriverRunpath ];

  postFixup = lib.optionalString cudaSupport (
    ''
      find $out -type f \( -name '*.so' -or -name '*.so.*' \) | while read lib; do
        addDriverRunpath "$lib"

        patchelf --set-rpath "${cudatoolkit}/lib:${cudatoolkit.lib}/lib:${cudnnMerged}/lib:${lib.getLib nccl}/lib:$(patchelf --print-rpath "$lib")" "$lib"
    ''
    + lib.optionalString stdenv.isLinux ''
      patchelf --set-rpath "${cudatoolkit}/lib:${cudatoolkit.lib}/lib:${cudnnMerged}/lib:${nccl}/lib:$(patchelf --print-rpath "$lib")" "$lib"
    ''
    + ''
      done
    ''
  );

  # Actual tests are slow and impure.
  # TODO try to run them anyway
  # TODO better test (files in tensorflow/tools/ci_build/builds/*test)
  # TEST_PACKAGES in tensorflow/tools/pip_package/setup.py
  nativeCheckInputs = [
    dill
    portpicker
    tblib
  ];
  checkPhase = ''
    ${python.interpreter} <<EOF
    # A simple "Hello world"
    import tensorflow as tf
    hello = tf.constant("Hello, world!")
    tf.print(hello)

    tf.random.set_seed(0)
    width = 512
    choice = 48
    t_in = tf.Variable(tf.random.uniform(shape=[width]))
    with tf.GradientTape() as tape:
        t_out = tf.slice(tf.nn.softmax(t_in), [choice], [1])
    diff = tape.gradient(t_out, t_in)
    assert(0 < tf.reduce_min(tf.slice(diff, [choice], [1])))
    assert(0 > tf.reduce_max(tf.slice(diff, [1], [choice - 1])))
    EOF
  '';
  # Regression test for #77626 removed because not more `tensorflow.contrib`.

  passthru = {
    deps = bazel-build.deps;
    libtensorflow = bazel-build.out;
    ml-dtypesTF = ml-dtypes;
  };

  inherit (bazel-build) meta;
}

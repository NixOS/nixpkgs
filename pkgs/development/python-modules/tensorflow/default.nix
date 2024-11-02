{
  stdenv,
  bazel_5,
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
  # Common deps
  git,
  pybind11,
  which,
  binutils,
  glibcLocales,
  cython,
  perl,
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
  llvmPackages,
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
  cudnnAttribute = "cudnn_8_6";
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

  version = "2.13.0";
  format = "setuptools";
  variant = lib.optionalString cudaSupport "-gpu";
  pname = "tensorflow${variant}";

  pythonEnv = python.withPackages (_: [
    # python deps needed during wheel build time (not runtime, see the buildPythonPackage part for that)
    # This list can likely be shortened, but each trial takes multiple hours so won't bother for now.
    absl-py
    astunparse
    dill
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
  bazel-build =
    if stdenv.hostPlatform.isDarwin then
      _bazel-build.overrideAttrs (prev: {
        bazelFlags = prev.bazelFlags ++ [
          "--override_repository=rules_cc=${rules_cc_darwin_patched}"
          "--override_repository=llvm-raw=${llvm-raw_darwin_patched}"
        ];
        preBuild = ''
          export AR="${cctools}/bin/libtool"
        '';
      })
    else
      _bazel-build;

  _bazel-build = buildBazelPackage.override { inherit stdenv; } {
    name = "${pname}-${version}";
    bazel = bazel_5;

    src = fetchFromGitHub {
      owner = "tensorflow";
      repo = "tensorflow";
      rev = "refs/tags/v${version}";
      hash = "sha256-Rq5pAVmxlWBVnph20fkAwbfy+iuBNlfFy14poDPd5h0=";
    };

    # On update, it can be useful to steal the changes from gentoo
    # https://gitweb.gentoo.org/repo/gentoo.git/tree/sci-libs/tensorflow

    nativeBuildInputs = [
      which
      pythonEnv
      cython
      perl
      protobuf-core
      protobuf-extra
    ] ++ lib.optional cudaSupport addDriverRunpath;

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
        (pybind11.overridePythonAttrs (_: {
          inherit stdenv;
        }))
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

    CC_OPT_FLAGS = " ";

    # https://github.com/tensorflow/tensorflow/issues/14454
    TF_NEED_MPI = tfFeature cudaSupport;

    TF_NEED_CUDA = tfFeature cudaSupport;
    TF_CUDA_PATHS = lib.optionalString cudaSupport "${cudatoolkitDevMerged},${cudnnMerged},${lib.getLib nccl}";
    TF_CUDA_COMPUTE_CAPABILITIES = lib.concatStringsSep "," cudaCapabilities;

    # Needed even when we override stdenv: e.g. for ar
    GCC_HOST_COMPILER_PREFIX = lib.optionalString cudaSupport "${cudatoolkit_cc_joined}/bin";
    GCC_HOST_COMPILER_PATH = lib.optionalString cudaSupport "${cudatoolkit_cc_joined}/bin/cc";

    patches = [
      "${gentoo-patches}/0002-systemlib-Latest-absl-LTS-has-split-cord-libs.patch"
      "${gentoo-patches}/0005-systemlib-Updates-for-Abseil-20220623-LTS.patch"
      "${gentoo-patches}/0007-systemlibs-Add-well_known_types_py_pb2-target.patch"
      # https://github.com/conda-forge/tensorflow-feedstock/pull/329/commits/0a63c5a962451b4da99a9948323d8b3ed462f461
      (fetchpatch {
        name = "fix-layout-proto-duplicate-loading.patch";
        url = "https://raw.githubusercontent.com/conda-forge/tensorflow-feedstock/0a63c5a962451b4da99a9948323d8b3ed462f461/recipe/patches/0001-Omit-linking-to-layout_proto_cc-if-protobuf-linkage-.patch";
        hash = "sha256-/7buV6DinKnrgfqbe7KKSh9rCebeQdXv2Uj+Xg/083w=";
      })
      ./com_google_absl_add_log.patch
      ./absl_py_argparse_flags.patch
      ./protobuf_python.patch
      ./pybind11_protobuf_python_runtime_dep.patch
      ./pybind11_protobuf_newer_version.patch
    ] ++ lib.optionals (stdenv.hostPlatform.system == "aarch64-darwin") [ ./absl_to_std.patch ];

    postPatch =
      ''
        # bazel 3.3 should work just as well as bazel 3.1
        rm -f .bazelversion
        patchShebangs .
      ''
      + lib.optionalString (stdenv.hostPlatform.system == "x86_64-darwin") ''
        cat ${./com_google_absl_fix_macos.patch} >> third_party/absl/com_google_absl_fix_mac_and_nvcc_build.patch
      ''
      + lib.optionalString (!withTensorboard) ''
        # Tensorboard pulls in a bunch of dependencies, some of which may
        # include security vulnerabilities. So we make it optional.
        # https://github.com/tensorflow/tensorflow/issues/20280#issuecomment-400230560
        sed -i '/tensorboard ~=/d' tensorflow/tools/pip_package/setup.py
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

        export PYTHON_LIB_PATH="$NIX_BUILD_TOP/site-packages"
        export CC_OPT_FLAGS="${lib.concatStringsSep " " opt_flags}"
        mkdir -p "$PYTHON_LIB_PATH"

        # To avoid mixing Python 2 and Python 3
        unset PYTHONPATH
      '';

    configurePhase = ''
      runHook preConfigure
      ./configure
      runHook postConfigure
    '';

    hardeningDisable = [ "format" ];

    bazelBuildFlags =
      [
        "--config=opt" # optimize using the flags set in the configure phase
      ]
      ++ lib.optionals stdenv.cc.isClang [
        "--cxxopt=-x"
        "--cxxopt=c++"
        "--host_cxxopt=-x"
        "--host_cxxopt=c++"

        # workaround for https://github.com/bazelbuild/bazel/issues/15359
        "--spawn_strategy=sandboxed"
      ]
      ++ lib.optionals (mklSupport) [ "--config=mkl" ];

    bazelTargets = [
      "//tensorflow/tools/pip_package:build_pip_package //tensorflow/tools/lib_package:libtensorflow"
    ];

    removeRulesCC = false;
    # Without this Bazel complaints about sandbox violations.
    dontAddBazelOpts = true;

    fetchAttrs = {
      sha256 =
        {
          x86_64-linux =
            if cudaSupport then
              "sha256-5VFMNHeLrUxW5RTr6EhT3pay9nWJ5JkZTGirDds5QkU="
            else
              "sha256-KzgWV69Btr84FdwQ5JI2nQEsqiPg1/+TWdbw5bmxXOE=";
          aarch64-linux =
            if cudaSupport then
              "sha256-ty5+51BwHWE1xR4/0WcWTp608NzSAS/iiyN+9zx7/wI="
            else
              "sha256-9btXrNHqd720oXTPDhSmFidv5iaZRLjCVX8opmrMjXk=";
          x86_64-darwin = "sha256-gqb03kB0z2pZQ6m1fyRp1/Nbt8AVVHWpOJSeZNCLc4w=";
          aarch64-darwin = "sha256-WdgAaFZU+ePwWkVBhLzjlNT7ELfGHOTaMdafcAMD5yo=";
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
        maintainers = with lib.maintainers; [ abbradar ];
        platforms = with lib.platforms; linux ++ darwin;
        broken =
          stdenv.hostPlatform.isDarwin
          || !(xlaSupport -> cudaSupport)
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
  disabled = pythonAtLeast "3.12";

  src = bazel-build.python;

  # Adjust dependency requirements:
  # - Drop tensorflow-io dependency until we get it to build
  # - Relax flatbuffers and gast version requirements
  # - The purpose of python3Packages.libclang is not clear at the moment and we don't have it packaged yet
  # - keras and tensorlow-io-gcs-filesystem will be considered as optional for now.
  postPatch = ''
    sed -i setup.py \
      -e '/tensorflow-io-gcs-filesystem/,+1d' \
      -e "s/'flatbuffers[^']*',/'flatbuffers',/" \
      -e "s/'gast[^']*',/'gast',/" \
      -e "/'libclang[^']*',/d" \
      -e "/'keras[^']*')\?,/d" \
      -e "/'tensorflow-io-gcs-filesystem[^']*',/d" \
      -e "s/'protobuf[^']*',/'protobuf',/" \
  '';

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
    six
    tensorflow-estimator-bin
    termcolor
    typing-extensions
    wrapt
  ] ++ lib.optionals withTensorboard [ tensorboard ];

  nativeBuildInputs = lib.optionals cudaSupport [ addDriverRunpath ];

  postFixup = lib.optionalString cudaSupport ''
    find $out -type f \( -name '*.so' -or -name '*.so.*' \) | while read lib; do
      addDriverRunpath "$lib"

      patchelf --set-rpath "${cudatoolkit}/lib:${cudatoolkit.lib}/lib:${cudnnMerged}/lib:${lib.getLib nccl}/lib:$(patchelf --print-rpath "$lib")" "$lib"
    done
  '';

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
  };

  inherit (bazel-build) meta;
}

{ stdenv, bazel_3, buildBazelPackage, isPy3k, lib, fetchFromGitHub, symlinkJoin
, addOpenGLRunpath, fetchpatch
# Python deps
, buildPythonPackage, pythonOlder, pythonAtLeast, python
# Python libraries
, numpy, tensorflow-tensorboard_2, absl-py
, future, setuptools, wheel, keras-preprocessing, google-pasta
, opt-einsum, astunparse, h5py
, termcolor, grpcio, six, wrapt, protobuf, tensorflow-estimator_2
, dill, flatbuffers-python, tblib, typing-extensions
# Common deps
, git, pybind11, which, binutils, glibcLocales, cython, perl
# Common libraries
, jemalloc, mpi, gast, grpc, sqlite, boringssl, jsoncpp
, curl, snappy, flatbuffers-core, lmdb-core, icu, double-conversion, libpng, libjpeg_turbo, giflib
# Upsteam by default includes cuda support since tensorflow 1.15. We could do
# that in nix as well. It would make some things easier and less confusing, but
# it would also make the default tensorflow package unfree. See
# https://groups.google.com/a/tensorflow.org/forum/#!topic/developers/iRCt5m4qUz0
, cudaSupport ? false, cudatoolkit ? null, cudnn ? null, nccl ? null
, mklSupport ? false, mkl ? null
, tensorboardSupport ? true
# XLA without CUDA is broken
, xlaSupport ? cudaSupport
# Default from ./configure script
, cudaCapabilities ? [ "sm_35" "sm_50" "sm_60" "sm_70" "sm_75" "compute_80" ]
, sse42Support ? stdenv.hostPlatform.sse4_2Support
, avx2Support  ? stdenv.hostPlatform.avx2Support
, fmaSupport   ? stdenv.hostPlatform.fmaSupport
# Darwin deps
, Foundation, Security
}:

assert cudaSupport -> cudatoolkit != null
                   && cudnn != null;

# unsupported combination
assert ! (stdenv.isDarwin && cudaSupport);

assert mklSupport -> mkl != null;

let
  withTensorboard = (pythonOlder "3.6") || tensorboardSupport;

  cudatoolkit_joined = symlinkJoin {
    name = "${cudatoolkit.name}-merged";
    paths = [
      cudatoolkit.lib
      cudatoolkit.out
    ] ++ lib.optionals (lib.versionOlder cudatoolkit.version "11") [
      # for some reason some of the required libs are in the targets/x86_64-linux
      # directory; not sure why but this works around it
      "${cudatoolkit}/targets/${stdenv.system}"
    ];
  };

  cudatoolkit_cc_joined = symlinkJoin {
    name = "${cudatoolkit.cc.name}-merged";
    paths = [
      cudatoolkit.cc
      binutils.bintools # for ar, dwp, nm, objcopy, objdump, strip
    ];
  };

  # Needed for _some_ system libraries, grep INCLUDEDIR.
  includes_joined = symlinkJoin {
    name = "tensorflow-deps-merged";
    paths = [
      jsoncpp
    ];
  };

  tfFeature = x: if x then "1" else "0";

  version = "2.4.2";
  variant = if cudaSupport then "-gpu" else "";
  pname = "tensorflow${variant}";

  pythonEnv = python.withPackages (_:
    [ # python deps needed during wheel build time (not runtime, see the buildPythonPackage part for that)
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
      protobuf
      setuptools
      six
      tblib
      tensorflow-estimator_2
      tensorflow-tensorboard_2
      termcolor
      typing-extensions
      wheel
      wrapt
  ]);

  bazel-build = buildBazelPackage {
    name = "${pname}-${version}";
    bazel = bazel_3;

    src = fetchFromGitHub {
      owner = "tensorflow";
      repo = "tensorflow";
      rev = "v${version}";
      sha256 = "07a2y05hixch1bjag5pzw3p1m7bdj3bq4gdvmsfk2xraz49b1pi8";
    };

    patches = [
      # included from 2.6.0 onwards
      (fetchpatch {
        name = "fix-numpy-1.20-notimplementederror.patch";
        url = "https://github.com/tensorflow/tensorflow/commit/b258941525f496763d4277045b6513c815720e3a.patch";
        sha256 = "19f9bzrcfsynk11s2hqvscin5c65zf7r6g3nb10jnimw79vafiry";
      })
      # Relax too strict Python packages versions dependencies.
      ./relax-dependencies.patch
      # Add missing `io_bazel_rules_docker` dependency.
      ./workspace.patch
    ];

    # On update, it can be useful to steal the changes from gentoo
    # https://gitweb.gentoo.org/repo/gentoo.git/tree/sci-libs/tensorflow

    nativeBuildInputs = [
      which pythonEnv cython perl
    ] ++ lib.optional cudaSupport addOpenGLRunpath;

    buildInputs = [
      jemalloc
      mpi
      glibcLocales
      git

      # libs taken from system through the TF_SYS_LIBS mechanism
      grpc
      sqlite
      boringssl
      jsoncpp
      curl
      pybind11
      snappy
      flatbuffers-core
      icu
      double-conversion
      libpng
      libjpeg_turbo
      giflib
      lmdb-core
    ] ++ lib.optionals cudaSupport [
      cudatoolkit
      cudnn
    ] ++ lib.optionals mklSupport [
      mkl
    ] ++ lib.optionals stdenv.isDarwin [
      Foundation
      Security
    ];

    # arbitrarily set to the current latest bazel version, overly careful
    TF_IGNORE_MAX_BAZEL_VERSION = true;

    # Take as many libraries from the system as possible. Keep in sync with
    # list of valid syslibs in
    # https://github.com/tensorflow/tensorflow/blob/master/third_party/systemlibs/syslibs_configure.bzl
    TF_SYSTEM_LIBS = lib.concatStringsSep "," [
      "absl_py"
      "astor_archive"
      "astunparse_archive"
      "boringssl"
      # Not packaged in nixpkgs
      # "com_github_googleapis_googleapis"
      # "com_github_googlecloudplatform_google_cloud_cpp"
      "com_github_grpc_grpc"
      # Multiple issues with custom protobuf.
      # First `com_github_googleapis` fails to configure. Can be worked around by disabling `com_github_googleapis`
      # and related functionality, but then the next error is about "dangling symbolic link", and in general
      # looks like that's only the beginning: see
      # https://stackoverflow.com/questions/55578884/how-to-build-tensorflow-1-13-1-with-custom-protobuf
      # "com_google_protobuf"
      # Fails with the error: external/org_tensorflow/tensorflow/core/profiler/utils/tf_op_utils.cc:46:49: error: no matching function for call to 're2::RE2::FullMatch(absl::lts_2020_02_25::string_view&, re2::RE2&)'
      # "com_googlesource_code_re2"
      "curl"
      "cython"
      "dill_archive"
      "double_conversion"
      "enum34_archive"
      "flatbuffers"
      "functools32_archive"
      "gast_archive"
      "gif"
      "hwloc"
      "icu"
      "jsoncpp_git"
      "libjpeg_turbo"
      "lmdb"
      "nasm"
      # "nsync" # not packaged in nixpkgs
      "opt_einsum_archive"
      "org_sqlite"
      "pasta"
      "pcre"
      "png"
      "pybind11"
      "six_archive"
      "snappy"
      "tblib_archive"
      "termcolor_archive"
      "typing_extensions_archive"
      "wrapt"
      "zlib"
    ];

    INCLUDEDIR = "${includes_joined}/include";

    PYTHON_BIN_PATH = pythonEnv.interpreter;

    TF_NEED_GCP = true;
    TF_NEED_HDFS = true;
    TF_ENABLE_XLA = tfFeature xlaSupport;

    CC_OPT_FLAGS = " ";

    # https://github.com/tensorflow/tensorflow/issues/14454
    TF_NEED_MPI = tfFeature cudaSupport;

    TF_NEED_CUDA = tfFeature cudaSupport;
    TF_CUDA_PATHS = lib.optionalString cudaSupport "${cudatoolkit_joined},${cudnn},${nccl}";
    GCC_HOST_COMPILER_PREFIX = lib.optionalString cudaSupport "${cudatoolkit_cc_joined}/bin";
    GCC_HOST_COMPILER_PATH = lib.optionalString cudaSupport "${cudatoolkit_cc_joined}/bin/gcc";
    TF_CUDA_COMPUTE_CAPABILITIES = lib.concatStringsSep "," cudaCapabilities;

    postPatch = ''
      # bazel 3.3 should work just as well as bazel 3.1
      rm -f .bazelversion
    '' + lib.optionalString (!withTensorboard) ''
      # Tensorboard pulls in a bunch of dependencies, some of which may
      # include security vulnerabilities. So we make it optional.
      # https://github.com/tensorflow/tensorflow/issues/20280#issuecomment-400230560
      sed -i '/tensorboard ~=/d' tensorflow/tools/pip_package/setup.py
    '';

    # https://github.com/tensorflow/tensorflow/pull/39470
    NIX_CFLAGS_COMPILE = [ "-Wno-stringop-truncation" ];

    preConfigure = let
      opt_flags = []
        ++ lib.optionals sse42Support ["-msse4.2"]
        ++ lib.optionals avx2Support ["-mavx2"]
        ++ lib.optionals fmaSupport ["-mfma"];
    in ''
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

    bazelBuildFlags = [
      "--config=opt" # optimize using the flags set in the configure phase
    ]
    ++ lib.optionals stdenv.cc.isClang [ "--cxxopt=-x" "--cxxopt=c++" "--host_cxxopt=-x" "--host_cxxopt=c++" ]
    ++ lib.optionals (mklSupport) [ "--config=mkl" ];

    bazelTarget = "//tensorflow/tools/pip_package:build_pip_package //tensorflow/tools/lib_package:libtensorflow";

    removeRulesCC = false;
    # Without this Bazel complaints about sandbox violations.
    dontAddBazelOpts = true;

    fetchAttrs = {
      # cudaSupport causes fetch of ncclArchive, resulting in different hashes
      sha256 = if cudaSupport then
        "10m6qj3kchgxfgb6qh59vc51knm9r9pkng8bf90h00dnggvv8234"
      else
        "04a98yrp09nd0p17k0jbzkgjppxs0yma7m5zkfrwgvr4g0w71v68";
    };

    buildAttrs = {
      outputs = [ "out" "python" ];

      preBuild = ''
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
          addOpenGLRunpath "$lib"
        done
      '';

      requiredSystemFeatures = [
        "big-parallel"
      ];
    };

    meta = with lib; {
      description = "Computation using data flow graphs for scalable machine learning";
      homepage = "http://tensorflow.org";
      license = licenses.asl20;
      maintainers = with maintainers; [ jyp abbradar ];
      platforms = with platforms; linux ++ darwin;
      broken = !(xlaSupport -> cudaSupport);
    };
  };

in buildPythonPackage {
  inherit version pname;
  disabled = !isPy3k;

  src = bazel-build.python;

  # Upstream has a pip hack that results in bin/tensorboard being in both tensorflow
  # and the propagated input tensorflow-tensorboard, which causes environment collisions.
  # Another possibility would be to have tensorboard only in the buildInputs
  # https://github.com/tensorflow/tensorflow/blob/v1.7.1/tensorflow/tools/pip_package/setup.py#L79
  postInstall = ''
    rm $out/bin/tensorboard
  '';

  setupPyGlobalFlags = [ "--project_name ${pname}" ];

  # tensorflow/tools/pip_package/setup.py
  propagatedBuildInputs = [
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
    protobuf
    six
    tblib
    tensorflow-estimator_2
    termcolor
    typing-extensions
    wrapt
  ] ++ lib.optionals withTensorboard [
    tensorflow-tensorboard_2
  ];

  nativeBuildInputs = lib.optional cudaSupport addOpenGLRunpath;

  postFixup = lib.optionalString cudaSupport ''
    find $out -type f \( -name '*.so' -or -name '*.so.*' \) | while read lib; do
      addOpenGLRunpath "$lib"

      patchelf --set-rpath "${cudatoolkit}/lib:${cudatoolkit.lib}/lib:${cudnn}/lib:${nccl}/lib:$(patchelf --print-rpath "$lib")" "$lib"
    done
  '';

  # Actual tests are slow and impure.
  # TODO try to run them anyway
  # TODO better test (files in tensorflow/tools/ci_build/builds/*test)
  checkPhase = ''
    ${python.interpreter} <<EOF
    # A simple "Hello world"
    import tensorflow as tf
    hello = tf.constant("Hello, world!")
    tf.print(hello)

    # Fit a simple model to random data
    import numpy as np
    np.random.seed(0)
    tf.random.set_seed(0)
    model = tf.keras.models.Sequential([
        tf.keras.layers.Dense(1, activation="linear")
    ])
    model.compile(optimizer="sgd", loss="mse")

    x = np.random.uniform(size=(1,1))
    y = np.random.uniform(size=(1,))
    model.fit(x, y, epochs=1)
    EOF
  '';
  # Regression test for #77626 removed because not more `tensorflow.contrib`.

  passthru = {
    deps = bazel-build.deps;
    libtensorflow = bazel-build.out;
  };

  inherit (bazel-build) meta;
}

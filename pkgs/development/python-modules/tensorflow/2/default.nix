{ stdenv, pkgs, bazel_0_29, buildBazelPackage, lib, fetchFromGitHub, fetchpatch, symlinkJoin
, addOpenGLRunpath
# Python deps
, buildPythonPackage, isPy3k, isPy27, pythonOlder, pythonAtLeast, python
# Python libraries
, numpy, tensorflow-tensorboard_2, backports_weakref, mock, enum34, absl-py
, future, setuptools, wheel, keras-preprocessing, keras-applications, google-pasta
, functools32
, opt-einsum
, termcolor, grpcio, six, wrapt, protobuf, tensorflow-estimator_2
# Common deps
, git, swig, which, binutils, glibcLocales, cython
# Common libraries
, jemalloc, openmpi, astor, gast, grpc, sqlite, openssl, jsoncpp, re2
, curl, snappy, flatbuffers, icu, double-conversion, libpng, libjpeg, giflib
# Upsteam by default includes cuda support since tensorflow 1.15. We could do
# that in nix as well. It would make some things easier and less confusing, but
# it would also make the default tensorflow package unfree. See
# https://groups.google.com/a/tensorflow.org/forum/#!topic/developers/iRCt5m4qUz0
, cudaSupport ? false, nvidia_x11 ? null, cudatoolkit ? null, cudnn ? null, nccl ? null
, mklSupport ? false, mkl ? null
# XLA without CUDA is broken
, xlaSupport ? cudaSupport
# Default from ./configure script
, cudaCapabilities ? [ "3.5" "5.2" ]
, sse42Support ? stdenv.hostPlatform.sse4_2Support
, avx2Support  ? stdenv.hostPlatform.avx2Support
, fmaSupport   ? stdenv.hostPlatform.fmaSupport
# Darwin deps
, Foundation, Security
}:

assert cudaSupport -> nvidia_x11 != null
                   && cudatoolkit != null
                   && cudnn != null;

# unsupported combination
assert ! (stdenv.isDarwin && cudaSupport);

assert mklSupport -> mkl != null;

let
  withTensorboard = pythonOlder "3.6";

  cudatoolkit_joined = symlinkJoin {
    name = "${cudatoolkit.name}-merged";
    paths = [
      cudatoolkit.lib
      cudatoolkit.out
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
      pkgs.protobuf
      jsoncpp
    ];
  };

  tfFeature = x: if x then "1" else "0";

  version = "2.1.0";
  variant = if cudaSupport then "-gpu" else "";
  pname = "tensorflow${variant}";

  pythonEnv = python.withPackages (_:
    [ # python deps needed during wheel build time (not runtime, see the buildPythonPackage part for that)
      numpy
      keras-preprocessing
      protobuf
      wrapt
      gast
      astor
      absl-py
      termcolor
      keras-applications
      setuptools
      wheel
  ] ++ lib.optionals (!isPy3k)
  [ future
    functools32
    mock
  ]);

  bazel-build = buildBazelPackage {
    name = "${pname}-${version}";
    bazel = bazel_0_29;

    src = fetchFromGitHub {
      owner = "tensorflow";
      repo = "tensorflow";
      rev = "v${version}";
      sha256 = "1g79xi8yl4sjia8ysk9b7xfzrz83zy28v5dlb2wzmcf0k5pmz60p";
    };

    patches = [
      # Work around https://github.com/tensorflow/tensorflow/issues/24752
      ../no-saved-proto.patch
      # Fixes for NixOS jsoncpp
      ../system-jsoncpp.patch

      (fetchpatch {
        name = "backport-pr-18950.patch";
        url = "https://github.com/tensorflow/tensorflow/commit/73640aaec2ab0234d9fff138e3c9833695570c0a.patch";
        sha256 = "1n9ypbrx36fc1kc9cz5b3p9qhg15xxhq4nz6ap3hwqba535nakfz";
      })

      (fetchpatch {
        # Don't try to fetch things that don't exist
        name = "prune-missing-deps.patch";
        url = "https://github.com/tensorflow/tensorflow/commit/b39b1ed24b4814db27d2f748dc85c10730ae851d.patch";
        sha256 = "1skysz53nancvw1slij6s7flar2kv3gngnsq60ff4lap88kx5s6c";
        excludes = [ "tensorflow/cc/saved_model/BUILD" ];
      })

      ./lift-gast-restriction.patch

      # cuda 10.2 does not have "-bin2c-path" option anymore
      # https://github.com/tensorflow/tensorflow/issues/34429
      ../cuda-10.2-no-bin2c-path.patch
    ];

    # On update, it can be useful to steal the changes from gentoo
    # https://gitweb.gentoo.org/repo/gentoo.git/tree/sci-libs/tensorflow

    nativeBuildInputs = [
      swig which pythonEnv
    ] ++ lib.optional cudaSupport addOpenGLRunpath;

    buildInputs = [
      jemalloc
      openmpi
      glibcLocales
      git

      # libs taken from system through the TF_SYS_LIBS mechanism
      # grpc
      sqlite
      openssl
      jsoncpp
      pkgs.protobuf
      curl
      snappy
      flatbuffers
      icu
      double-conversion
      libpng
      libjpeg
      giflib
      re2
      pkgs.lmdb
    ] ++ lib.optionals cudaSupport [
      cudatoolkit
      cudnn
      nvidia_x11
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
      "boringssl"
      # Not packaged in nixpkgs
      # "com_github_googleapis_googleapis"
      # "com_github_googlecloudplatform_google_cloud_cpp"
      "com_google_protobuf"
      "com_googlesource_code_re2"
      "curl"
      "cython"
      "double_conversion"
      "flatbuffers"
      "gast_archive"
      # Lots of errors, requires an older version
      # "grpc"
      "hwloc"
      "icu"
      "jpeg"
      "jsoncpp_git"
      "keras_applications_archive"
      "lmdb"
      "nasm"
      # "nsync" # not packaged in nixpkgs
      "opt_einsum_archive"
      "org_sqlite"
      "pasta"
      "pcre"
      "six_archive"
      "snappy"
      "swig"
      "termcolor_archive"
      "wrapt"
      "zlib_archive"
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
      # https://github.com/tensorflow/tensorflow/issues/20919
      sed -i '/androidndk/d' tensorflow/lite/kernels/internal/BUILD

      # Tensorboard pulls in a bunch of dependencies, some of which may
      # include security vulnerabilities. So we make it optional.
      # https://github.com/tensorflow/tensorflow/issues/20280#issuecomment-400230560
      sed -i '/tensorboard >=/d' tensorflow/tools/pip_package/setup.py
    '';

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

    # FIXME: Tensorflow uses dlopen() for CUDA libraries.
    NIX_LDFLAGS = lib.optionalString cudaSupport "-lcudart -lcublas -lcufft -lcurand -lcusolver -lcusparse -lcudnn";

    hardeningDisable = [ "format" ];

    bazelFlags = [
      # temporary fixes to make the build work with bazel 0.27
      "--incompatible_no_support_tools_in_action_inputs=false"
    ];
    bazelBuildFlags = [
      "--config=opt" # optimize using the flags set in the configure phase
    ]
    ++ lib.optionals (mklSupport) [ "--config=mkl" ];

    bazelTarget = "//tensorflow/tools/pip_package:build_pip_package //tensorflow/tools/lib_package:libtensorflow";

    fetchAttrs = {
      # So that checksums don't depend on these.
      TF_SYSTEM_LIBS = null;

      # cudaSupport causes fetch of ncclArchive, resulting in different hashes
      sha256 = if cudaSupport then
        "1kqk1gx5g63kb2zdj392x6mnpbrmgqghrdv597aipn7s23xzj8pd"
      else
        "1plpcm2ydpajsrxdvmmpfy7l0gfdir78hap72w4k7ddm6d3rm2fv";
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
    };

    meta = with stdenv.lib; {
      description = "Computation using data flow graphs for scalable machine learning";
      homepage = "http://tensorflow.org";
      license = licenses.asl20;
      maintainers = with maintainers; [ jyp abbradar ];
      platforms = with platforms; linux ++ darwin;
      # The py2 build fails due to some issue importing protobuf. Possibly related to the fix in
      # https://github.com/akesandgren/easybuild-easyblocks/commit/1f2e517ddfd1b00a342c6abb55aef3fd93671a2b
      broken = !(xlaSupport -> cudaSupport) || !isPy3k;
    };
  };

in buildPythonPackage {
  inherit version pname;
  disabled = isPy27 || (pythonAtLeast "3.8");

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
    astor
    gast
    google-pasta
    keras-applications
    keras-preprocessing
    numpy
    six
    protobuf
    tensorflow-estimator_2
    termcolor
    wrapt
    grpcio
    opt-einsum
  ] ++ lib.optionals (!isPy3k) [
    mock
    future
    functools32
  ] ++ lib.optionals (pythonOlder "3.4") [
    backports_weakref enum34
  ] ++ lib.optionals withTensorboard [
    tensorflow-tensorboard_2
  ];

  nativeBuildInputs = lib.optional cudaSupport addOpenGLRunpath;

  postFixup = lib.optionalString cudaSupport ''
    find $out -type f \( -name '*.so' -or -name '*.so.*' \) | while read lib; do
      addOpenGLRunpath "$lib"
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

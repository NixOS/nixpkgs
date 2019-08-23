{ stdenv, pkgs, buildBazelPackage, lib, fetchFromGitHub, fetchpatch, symlinkJoin
# Python deps
, buildPythonPackage, isPy3k, pythonOlder, pythonAtLeast, python
# Python libraries
, numpy, tensorflow-tensorboard, backports_weakref, mock, enum34, absl-py
, future, setuptools, wheel, keras-preprocessing, keras-applications, google-pasta
, termcolor, grpcio, six, wrapt, protobuf, tensorflow-estimator
# Common deps
, git, swig, which, binutils, glibcLocales, cython
# Common libraries
, jemalloc, openmpi, astor, gast, grpc, sqlite, openssl, jsoncpp, re2
, curl, snappy, flatbuffers, icu, double-conversion, libpng, libjpeg, giflib
, cudaSupport ? false, nvidia_x11 ? null, cudatoolkit ? null, cudnn ? null, nccl ? null
# XLA without CUDA is broken
, xlaSupport ? cudaSupport
# Default from ./configure script
, cudaCapabilities ? [ "3.5" "5.2" ]
, sse42Support ? builtins.elem (stdenv.hostPlatform.platform.gcc.arch or "default") ["westmere" "sandybridge" "ivybridge" "haswell" "broadwell" "skylake" "skylake-avx512"]
, avx2Support  ? builtins.elem (stdenv.hostPlatform.platform.gcc.arch or "default") [                                     "haswell" "broadwell" "skylake" "skylake-avx512"]
, fmaSupport   ? builtins.elem (stdenv.hostPlatform.platform.gcc.arch or "default") [                                     "haswell" "broadwell" "skylake" "skylake-avx512"]
}:

assert cudaSupport -> nvidia_x11 != null
                   && cudatoolkit != null
                   && cudnn != null;

# unsupported combination
assert ! (stdenv.isDarwin && cudaSupport);

let
  withTensorboard = pythonOlder "3.6";

  cudatoolkit_joined = symlinkJoin {
    name = "${cudatoolkit.name}-merged";
    paths = [ cudatoolkit.out cudatoolkit.lib ];
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

  version = "1.14.0";
  variant = if cudaSupport then "-gpu" else "";
  pname = "tensorflow${variant}";

  # TODO: remove after there's support for setupPyDistFlags
  setuppy = ../../../development/interpreters/python/run_setup.py;

  bazel-build = buildBazelPackage rec {
    name = "${pname}-${version}";

    src = fetchFromGitHub {
      owner = "tensorflow";
      repo = "tensorflow";
      rev = "v${version}";
      sha256 = "06jvwlsm14b8rqwd8q8796r0vmn0wk64s4ps2zg0sapkmp9vvcmi";
    };

    patches = [
      # Work around https://github.com/tensorflow/tensorflow/issues/24752
      ./no-saved-proto.patch
      # Fixes for NixOS jsoncpp
      ./system-jsoncpp.patch

      # https://github.com/tensorflow/tensorflow/pull/29673
      (fetchpatch {
        name = "fix-compile-with-cuda-and-mpi.patch";
        url = "https://github.com/tensorflow/tensorflow/pull/29673/commits/498e35a3bfe38dd75cf1416a1a23c07c3b59e6af.patch";
        sha256 = "1m2qmwv1ysqa61z6255xggwbq6mnxbig749bdvrhnch4zydxb4di";
      })

      # https://github.com/tensorflow/tensorflow/issues/29220
      (fetchpatch {
        name = "bazel-0.27.patch";
        url = "https://github.com/tensorflow/tensorflow/commit/cfccbdb8c4a92dd26382419dceb4d934c2380391.patch";
        sha256 = "1l56wjia2c4685flsfkkgy471wx3c66wyv8khspv06zchj0k0liw";
      })
    ];

    # On update, it can be useful to steal the changes from gentoo
    # https://gitweb.gentoo.org/repo/gentoo.git/tree/sci-libs/tensorflow

    nativeBuildInputs = [
      swig which cython
    ];

    buildInputs = [
      python
      jemalloc
      openmpi
      glibcLocales
      git

      # python deps needed during wheel build time
      numpy
      keras-preprocessing
      protobuf
      wrapt
      gast
      astor
      absl-py
      termcolor
      keras-applications

      # libs taken from system through the TF_SYS_LIBS mechanism
      grpc
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

      # for building the wheel
      setuptools
      wheel
    ] ++ lib.optionals (!isPy3k) [
      future
      mock
    ] ++ lib.optionals cudaSupport [
      cudatoolkit
      cudnn
      nvidia_x11
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
      "com_google_protobuf_cc"
      "com_googlesource_code_re2"
      "curl"
      "cython"
      "double_conversion"
      "flatbuffers"
      "gast_archive"
      "gif_archive"
      "grpc"
      "hwloc"
      "icu"
      "jpeg"
      "jsoncpp_git"
      "keras_applications_archive"
      "lmdb"
      "nasm"
      # "nsync" # not packaged in nixpkgs
      "org_sqlite"
      "pasta"
      "pcre"
      "png_archive"
      "protobuf_archive"
      "six_archive"
      "snappy"
      "swig"
      "termcolor_archive"
      "wrapt"
      "zlib_archive"
    ];

    INCLUDEDIR = "${includes_joined}/include";

    PYTHON_BIN_PATH = python.interpreter;
 
    TF_NEED_GCP = true;
    TF_NEED_HDFS = true;
    TF_ENABLE_XLA = tfFeature xlaSupport;

    CC_OPT_FLAGS = " ";

    # https://github.com/tensorflow/tensorflow/issues/14454
    TF_NEED_MPI = tfFeature cudaSupport;

    TF_NEED_CUDA = tfFeature cudaSupport;
    TF_CUDA_PATHS = lib.optionalString cudaSupport "${cudatoolkit_joined},${cudnn},${nccl}";
    GCC_HOST_COMPILER_PREFIX = lib.optionalString cudaSupport "${cudatoolkit_cc_joined}/bin";
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
    '';

    configurePhase = ''
      runHook preConfigure
      ./configure
      runHook postConfigure
    '';

    # FIXME: Tensorflow uses dlopen() for CUDA libraries.
    # No idea why gpr isn't linked properly; perhaps Tensorflow expects a static library?
    NIX_LDFLAGS = [ "-lgpr" ] ++ lib.optionals cudaSupport [ "-lcudart" "-lcublas" "-lcufft" "-lcurand" "-lcusolver" "-lcusparse" "-lcudnn" ];

    hardeningDisable = [ "format" ];

    bazelFlags = [
      # temporary fixes to make the build work with bazel 0.27
      "--incompatible_no_support_tools_in_action_inputs=false"
    ];
    bazelBuildFlags = [
      "--config=opt" # optimize using the flags set in the configure phase
    ];

    bazelTarget = "//tensorflow/tools/pip_package:build_pip_package //tensorflow/tools/lib_package:libtensorflow";

    fetchAttrs = {
      preInstall = ''
        rm -rf $bazelOut/external/{bazel_tools,\@bazel_tools.marker,local_*,\@local_*}
      '';

      # cudaSupport causes fetch of ncclArchive, resulting in different hashes
      sha256 = if cudaSupport then
        "19ll3f1i5qzd7ngz3m2jbxzgcrdjx5sv6kv2j5mcb8g3xsws8j5x"
      else
        "0y9kw3k4yvrxwdy7zry7nip9mdiwyv35r6mx65g4w7qajiypfc7i";
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
    };
  };

in buildPythonPackage rec {
  inherit version pname;

  src = bazel-build.python;

  # Upstream has a pip hack that results in bin/tensorboard being in both tensorflow
  # and the propagated input tensorflow-tensorboard, which causes environment collisions.
  # Another possibility would be to have tensorboard only in the buildInputs
  # https://github.com/tensorflow/tensorflow/blob/v1.7.1/tensorflow/tools/pip_package/setup.py#L79
  postInstall = ''
    rm $out/bin/tensorboard
  '';

  # TODO: remove after there's support for setupPyDistFlags
  buildPhase = ''
    runHook preBuild
    cp ${setuppy} nix_run_setup
    ${python.interpreter} nix_run_setup --project_name ${pname} bdist_wheel
    runHook postBuild
  '';

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
    tensorflow-estimator
    termcolor
    wrapt
    grpcio
  ] ++ lib.optionals (!isPy3k) [
    mock
    future # FIXME
  ] ++ lib.optionals (pythonOlder "3.4") [
    backports_weakref enum34
  ] ++ lib.optionals withTensorboard [
    tensorflow-tensorboard
  ];

  # Actual tests are slow and impure.
  # TODO try to run them anyway
  # TODO better test (files in tensorflow/tools/ci_build/builds/*test)
  checkPhase = ''
    ${python.interpreter} -c "import tensorflow"
  '';

  passthru.libtensorflow = bazel-build.out;

  meta = with stdenv.lib; {
    description = "Computation using data flow graphs for scalable machine learning";
    homepage = http://tensorflow.org;
    license = licenses.asl20;
    maintainers = with maintainers; [ jyp abbradar ];
    platforms = platforms.linux;
    broken = !(xlaSupport -> cudaSupport);
  };
}

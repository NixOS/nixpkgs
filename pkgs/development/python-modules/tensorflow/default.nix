{ stdenv, buildBazelPackage, lib, fetchFromGitHub, fetchpatch, symlinkJoin
, git
, buildPythonPackage, isPy3k, pythonOlder, pythonAtLeast
, which, binutils, glibcLocales
, python, jemalloc, openmpi
, numpy, tensorflow-tensorboard, backports_weakref, mock, enum34, absl-py
, future
, keras-preprocessing
, keras-applications
, astor
, gast
, google-pasta
, termcolor
, cython
, flatbuffers
, giflib
, libjpeg
, grpc
, grpcio
, hwloc
, icu
, jsoncpp
, lmdb
, nasm
, sqlite
, pcre
, libpng
, six
, snappy
, swig
, wrapt
, zlib
, protobuf
, protobuf_cc
, curl
, tensorflow-estimator
, setuptools
, wheel
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
    name = "${cudatoolkit.name}-unsplit";
    paths = [ cudatoolkit.out cudatoolkit.lib ];
  };

  bazel_cuda_toolkit = symlinkJoin {
    name = "bazel-gcc-toolkit";
    paths = [
      cudatoolkit.cc
      cudatoolkit.out
      cudatoolkit.lib
      binutils.bintools # for ar, dwp, nm, objcopy, objdump, strip
    ];
  };

  tfFeature = x: if x then "1" else "0";

  version = "1.14";
  variant = if cudaSupport then "_gpu" else "";
  pname = "tensorflow${variant}";

  bazel-wheel = buildBazelPackage rec {
    # indicate which configuration of the wheel is being built
    name = let
      python_tag = with lib.versions; "cp${major python.version}${minor python.version}"; # cp37
      arch_platform = lib.splitString "-" stdenv.hostPlatform.system;
      platform = lib.last arch_platform; # "linux"
      arch = lib.head arch_platform; # "x86_64"
    in
      # https://www.python.org/dev/peps/pep-0427/#file-name-convention
      # tensorflow_gpu-1.14.0-cp27-none-linux_x86_64.whl
      "${pname}-${version}-${python_tag}-none-${platform}_${arch}.whl";

    src = fetchFromGitHub {
      owner = "tensorflow";
      repo = "tensorflow";
      rev = "r${version}";
      sha256 = "071rndqh3xy4y5idlykqv656lggp25vy4qx1divz4id3im1zlr13";
    };

    patches = [
      # Work around https://github.com/tensorflow/tensorflow/issues/24752
      ./no-saved-proto.patch

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

    nativeBuildInputs = [ swig which ];

    buildInputs = [
      python
      jemalloc
      openmpi
      glibcLocales
      git

      # python deps needed during wheel build time
      numpy
      keras-preprocessing

      # libs taken from system through the TF_SYS_LIBS mechanism
      absl-py

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

    # Take as many libraries from the system as possible. Keep in sync with
    # list of valid syslibs in
    # https://github.com/perfinion/tensorflow/blob/master/third_party/systemlibs/syslibs_configure.bzl
    SYSLIBS= [
      "absl_py"
      "astor_archive"
      "boringssl"
      "com_github_googleapis_googleapis"
      "com_github_googlecloudplatform_google_cloud_cpp"
      "com_google_protobuf"
      "com_google_protobuf_cc"
      "com_googlesource_code_re2"
      "curl"
      "cython"
      "double_conversion"
      "enum34_archive"
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
      "sqlite"
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

    preConfigure = ''
      patchShebangs configure

      # dummy ldconfig
      mkdir dummy-ldconfig
      echo "#!${stdenv.shell}" > dummy-ldconfig/ldconfig
      chmod +x dummy-ldconfig/ldconfig
      export PATH="$PWD/dummy-ldconfig:$PATH"

      # arbitrarily set to the current latest bazel version, overly careful
      export TF_IGNORE_MAX_BAZEL_VERSION=1

      # don't rebuild the world
      export TF_SYSTEM_LIBS=${lib.concatStringsSep " " SYSLIBS}

      export PYTHON_BIN_PATH="${python.interpreter}"
      export PYTHON_LIB_PATH="$NIX_BUILD_TOP/site-packages"
      export TF_NEED_GCP=1
      export TF_NEED_HDFS=1
      export TF_ENABLE_XLA=${tfFeature xlaSupport}
      export CC_OPT_FLAGS=" "
      # https://github.com/tensorflow/tensorflow/issues/14454
      export TF_NEED_MPI=${tfFeature cudaSupport}
      export TF_NEED_CUDA=${tfFeature cudaSupport}
      ${lib.optionalString cudaSupport ''
        export TF_CUDA_PATHS="${cudatoolkit_joined},${cudnn},${nccl}"
        export TF_CUDA_VERSION=${cudatoolkit.majorVersion}
        export TF_CUDNN_VERSION=${cudnn.majorVersion}
        export GCC_HOST_COMPILER_PATH=${bazel_cuda_toolkit}/bin/gcc
        export GCC_HOST_COMPILER_PREFIX="${bazel_cuda_toolkit}/bin"
        export TF_CUDA_COMPUTE_CAPABILITIES=${lib.concatStringsSep "," cudaCapabilities}
      ''}

      # https://github.com/tensorflow/tensorflow/issues/20919
      sed -i '/androidndk/d' tensorflow/lite/kernels/internal/BUILD

      mkdir -p "$PYTHON_LIB_PATH"
    '';

    # ar, cpp, gcov, strip, gcc, compat-ld, ld, objdump, dwp, nm, objcopy
    configurePhase = ''
      runHook preConfigure
      # no flags (options provided by previously set environment variables)
      export AR="${binutils.bintools}/bin/ar"
      export BAZEL_TOOLS_OVERRIDE="ar=${binutils.bintools}/bin/ar"
      # crosstool used with cuda
      ./configure

      runHook postConfigure
    '';

    # FIXME
    NIX_LDFLAGS = lib.optionals cudaSupport [ "-lcublas" "-lcudnn" "-lcuda" "-lcudart" ];

    hardeningDisable = [ "all" ];

    bazelFlags = [
      # temporary fixes to make the build work with bazel 0.27
      "--incompatible_no_support_tools_in_action_inputs=false"
    ] ++ lib.optional sse42Support "--copt=-msse4.2"
      ++ lib.optional avx2Support "--copt=-mavx2"
      ++ lib.optional fmaSupport "--copt=-mfma";

    bazelTarget = "//tensorflow/tools/pip_package:build_pip_package";

    fetchAttrs = {
      preInstall = ''
        rm -rf $bazelOut/external/{bazel_tools,\@bazel_tools.marker,local_*,\@local_*}
      '';

      # cudaSupport causes fetch of ncclArchive, resulting in different hashes
      sha256 = if cudaSupport then
        "0q1pmw7fzn6l554ap576r48m0zgwb7n1ljhyy1p36708z94scdh4"
      else
        "14n26h2r4w7wd5sddy4w0s51s2qcwf276n3hvv2505iysa8wqlc3";
    };

    buildAttrs = {
      preBuild = ''
        patchShebangs .

        # beautiful bash to iterate over files containing a string
        # https://github.com/bazelbuild/bazel/issues/5915#issuecomment-505100422
        # .. to make sure the output directory is covered
        grep -lrZ '/usr/bin/ar\b' .. | while IFS="" read -r -d "" file; do
            # patch /usr/bin/ar to the proper location
            echo "File is $file"
            sed -i \
              -e 's,/usr/bin/ar\b,${binutils.bintools}/bin/ar,g' \
              "$file"
        done


        # Tensorboard pulls in a bunch of dependencies, some of which may
        # include security vulnerabilities. So we make it optional.
        # https://github.com/tensorflow/tensorflow/issues/20280#issuecomment-400230560
        sed -i '/tensorboard >=/d' tensorflow/tools/pip_package/setup.py
      '';

      # Could alternatively use --src instead of --dst to output the sources
      # instead of a whee. Generating a wheel makes it easier to unify handling
      # of source and binary build though.
      installPhase = ''
        # work around timestamp issues
        # https://github.com/NixOS/nixpkgs/issues/270#issuecomment-467583872
        export SOURCE_DATE_EPOCH=315532800

        # bulid the wheel, then move it to $out (building directly to $out
        # would actually put it into a *directory* called $out, but we want the
        # file itself in $out)
        bazel-bin/tensorflow/tools/pip_package/build_pip_package --dst $PWD/dist
        mv dist/*.whl "$out"
      '';
    };
  };

in buildPythonPackage rec {
  inherit version pname;

  src = bazel-wheel;

  format = "wheel";

  # Upstream has a pip hack that results in bin/tensorboard being in both tensorflow
  # and the propagated input tensorflow-tensorboard, which causes environment collisions.
  # Another possibility would be to have tensorboard only in the buildInputs
  # https://github.com/tensorflow/tensorflow/blob/v1.7.1/tensorflow/tools/pip_package/setup.py#L79
  postInstall = ''
    rm $out/bin/tensorboard
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

  meta = with stdenv.lib; {
    description = "Computation using data flow graphs for scalable machine learning";
    homepage = http://tensorflow.org;
    license = licenses.asl20;
    maintainers = with maintainers; [ jyp abbradar ];
    platforms = platforms.linux;
    broken = !(xlaSupport -> cudaSupport);
  };
}

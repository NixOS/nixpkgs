{ stdenv, lib, fetchFromGitHub, fetchpatch, symlinkJoin, buildPythonPackage, isPy3k, pythonOlder
, bazel, which, swig, binutils, glibcLocales
, python, jemalloc, openmpi
, numpy, six, protobuf, tensorflow-tensorboard, backports_weakref
, wheel, mock, scipy
, xlaSupport ? true
, cudaSupport ? false, nvidia_x11 ? null, cudatoolkit ? null, cudnn ? null
# Default from ./configure script
, cudaCapabilities ? [ "3.5" "5.2" ]
, sse42Support ? false
, avx2Support ? false
, fmaSupport ? false
}:

assert cudaSupport -> cudatoolkit != null
                   && cudnn != null;

# unsupported combination
assert ! (stdenv.isDarwin && cudaSupport);

let

  withTensorboard = pythonOlder "3.6";

  cudatoolkit_joined = symlinkJoin {
    name = "${cudatoolkit.name}-unsplit";
    paths = [ cudatoolkit.out cudatoolkit.lib ];
  };

  cudaLibPath = lib.makeLibraryPath [ cudatoolkit.out cudatoolkit.lib nvidia_x11 cudnn ];

  tfFeature = x: if x then "1" else "0";

  common = rec {
    version = "1.3.1";

    src = fetchFromGitHub {
      owner = "tensorflow";
      repo = "tensorflow";
      rev = "v${version}";
      sha256 = "0gvi32dvv4ynr05p0gg5i0a6c55pig48k5qm7zslcqnp4sifwx0i";
    };

    nativeBuildInputs = [ swig which wheel scipy ];

    buildInputs = [ python jemalloc openmpi glibcLocales ]
      ++ lib.optionals cudaSupport [ cudatoolkit cudnn ];

    propagatedBuildInputs = [ numpy six protobuf ]
                            ++ lib.optional (!isPy3k) mock
                            ++ lib.optional (pythonOlder "3.4") backports_weakref
                            ++ lib.optional withTensorboard tensorflow-tensorboard;

    preConfigure = ''
      patchShebangs configure
      export HOME="$NIX_BUILD_TOP"

      export PYTHON_BIN_PATH="${python.interpreter}"
      export TF_NEED_GCP=1
      export TF_NEED_HDFS=1
      export TF_NEED_CUDA=${tfFeature cudaSupport}
      export TF_NEED_MPI=1
      export TF_ENABLE_XLA=${tfFeature xlaSupport}
      ${lib.optionalString cudaSupport ''
        export CUDA_TOOLKIT_PATH=${cudatoolkit_joined}
        export TF_CUDA_VERSION=${cudatoolkit.majorVersion}
        export CUDNN_INSTALL_PATH=${cudnn}
        export TF_CUDNN_VERSION=${cudnn.majorVersion}
        export GCC_HOST_COMPILER_PATH=${cudatoolkit.cc}/bin/gcc
        export TF_CUDA_COMPUTE_CAPABILITIES=${lib.concatStringsSep "," cudaCapabilities}
      ''}

      # There is _no_ non-interactive mode of configure.
      sed -i \
        -e 's,read -p,echo,g' \
        -e 's,lib64,lib,g' \
        configure
    '';

    hardeningDisable = [ "all" ];

    bazelFlags = [ "--config=opt" ]
                 ++ lib.optional sse42Support "--copt=-msse4.2"
                 ++ lib.optional avx2Support "--copt=-mavx2"
                 ++ lib.optional fmaSupport "--copt=-mfma"
                 ++ lib.optional cudaSupport "--config=cuda";

    bazelTarget = "//tensorflow/tools/pip_package:build_pip_package";

    meta = with stdenv.lib; {
      description = "Computation using data flow graphs for scalable machine learning";
      homepage = "http://tensorflow.org";
      license = licenses.asl20;
      maintainers = with maintainers; [ jyp abbradar ];
      platforms = with platforms; if cudaSupport then linux else linux ++ darwin;
    };
  };

in buildPythonPackage (common // {
  name = "tensorflow-${common.version}";

  deps = stdenv.mkDerivation (common // {
    name = "tensorflow-external-${common.version}";

    nativeBuildInputs = common.nativeBuildInputs ++ [ bazel ];

    preConfigure = common.preConfigure + ''
      export PYTHON_LIB_PATH="$(pwd)/site-packages"
    '';

    buildPhase = ''
      mkdir site-packages
      bazel --output_base="$(pwd)/output" fetch $bazelFlags $bazelTarget
    '';

    installPhase = ''
      rm -rf output/external/{bazel_tools,\@bazel_tools.marker,local_*,\@local_*}
      # Patching markers to make them deterministic
      for i in output/external/\@*.marker; do
        sed -i 's, -\?[0-9][0-9]*$, 1,' "$i"
      done
      # Patching symlinks to remove build directory reference
      find output/external -type l | while read symlink; do
        ln -sf $(readlink "$symlink" | sed "s,$NIX_BUILD_TOP,NIX_BUILD_TOP,") "$symlink"
      done

      cp -r output/external $out
    '';

    dontFixup = true;

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "0xs2n061gnpizfcnhs5jjpfk2av634j1l2l17zhy10bbmrwn3vrp";
  });

  nativeBuildInputs = common.nativeBuildInputs ++ [ (bazel.override { enableNixHacks = true; }) ];

  configurePhase = ''
    runHook preConfigure
    export PYTHON_LIB_PATH="$out/${python.sitePackages}"
    ./configure
    runHook postConfigure
  '';

  buildPhase = ''
    mkdir -p output/external
    cp -r $deps/* output/external
    chmod -R +w output
    find output -type l | while read symlink; do
      ln -sf $(readlink "$symlink" | sed "s,NIX_BUILD_TOP,$NIX_BUILD_TOP,") "$symlink"
    done

    patchShebangs .
    find -type f -name CROSSTOOL\* -exec sed -i \
      -e 's,/usr/bin/ar,${binutils}/bin/ar,g' \
      {} \;

    mkdir -p $out/${python.sitePackages}
    bazel --output_base="$(pwd)/output" build $bazelFlags $bazelTarget

    bazel-bin/tensorflow/tools/pip_package/build_pip_package $PWD/dist
  '';

  # tensorflow depends on tensorflow_tensorboard, which cannot be
  # built at the moment (some of its dependencies do not build
  # [htlm5lib9999999 (seven nines) -> tensorboard], and it depends on an old version of
  # bleach) Hence we disable dependency checking for now.
  installFlags = lib.optional (!withTensorboard) "--no-dependencies";

  # Tests are slow and impure.
  doCheck = false;

  # For some reason, CUDA is not retained in RPATH.
  postFixup = lib.optionalString cudaSupport ''
    libPath="$out/${python.sitePackages}/tensorflow/python/_pywrap_tensorflow_internal.so"
    patchelf --set-rpath "$(patchelf --print-rpath "$libPath"):${cudaLibPath}" "$libPath"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    cd $NIX_BUILD_TOP
    ${python.interpreter} -c "import tensorflow"
  '';
})

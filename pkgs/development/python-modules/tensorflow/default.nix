{ stdenv, bazel_5, buildBazelPackage, isPy3k, lib, fetchFromGitHub, symlinkJoin
, addOpenGLRunpath, fetchpatch, patchelfUnstable
# Python deps
, buildPythonPackage, pythonOlder, python
# Python libraries
, numpy, tensorboard, absl-py
, packaging, setuptools, wheel, keras, keras-preprocessing, google-pasta
, opt-einsum, astunparse, h5py
, termcolor, grpcio, six, wrapt, protobuf-python, tensorflow-estimator-bin
, dill, flatbuffers-python, portpicker, tblib, typing-extensions
# Common deps
, git, pybind11, which, binutils, glibcLocales, cython, perl, coreutils
# Common libraries
, jemalloc, mpi, gast, grpc, sqlite, boringssl, jsoncpp, nsync
, curl, snappy, flatbuffers-core, lmdb-core, icu, double-conversion, libpng, libjpeg_turbo, giflib, protobuf-core
# Upstream by default includes cuda support since tensorflow 1.15. We could do
# that in nix as well. It would make some things easier and less confusing, but
# it would also make the default tensorflow package unfree. See
# https://groups.google.com/a/tensorflow.org/forum/#!topic/developers/iRCt5m4qUz0
, cudaSupport ? false, cudaPackages ? {}
, mklSupport ? false, mkl ? null
, tensorboardSupport ? true
# XLA without CUDA is broken
, xlaSupport ? cudaSupport
, sse42Support ? stdenv.hostPlatform.sse4_2Support
, avx2Support  ? stdenv.hostPlatform.avx2Support
, fmaSupport   ? stdenv.hostPlatform.fmaSupport
# Darwin deps
, Foundation, Security, cctools, llvmPackages_11
}:

let
  inherit (cudaPackages) cudatoolkit cudaFlags cudnn nccl;
in

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

  version = "2.11.0";
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
        sha256 = "sha256-C4v6HY5+jm0ACUZ58gBPVejCYCZfuzYKlHZ0m2qDHCk=";
      })

      # https://github.com/bazelbuild/rules_cc/pull/124
      (fetchpatch {
        name = "tensorflow-rules_cc-install_name_tool-path.patch";
        url = "https://github.com/bazelbuild/rules_cc/commit/156497dc89100db8a3f57b23c63724759d431d05.diff";
        sha256 = "sha256-NES1KeQmMiUJQVoV6dS4YGRxxkZEjOpFSCyOq9HZYO0=";
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
  bazel-build = if stdenv.isDarwin then _bazel-build.overrideAttrs (prev: {
    bazelFlags = prev.bazelFlags ++ [
      "--override_repository=rules_cc=${rules_cc_darwin_patched}"
      "--override_repository=llvm-raw=${llvm-raw_darwin_patched}"
    ];
    preBuild = ''
      export AR="${cctools}/bin/libtool"
    '';
  }) else _bazel-build;

  _bazel-build = (buildBazelPackage.override (lib.optionalAttrs stdenv.isDarwin {
    # clang 7 fails to emit a symbol for
    # __ZN4llvm11SmallPtrSetIPKNS_10AllocaInstELj8EED1Ev in any of the
    # translation units, so the build fails at link time
    stdenv = llvmPackages_11.stdenv;
  })) {
    name = "${pname}-${version}";
    bazel = bazel_5;

    src = fetchFromGitHub {
      owner = "tensorflow";
      repo = "tensorflow";
      rev = "refs/tags/v${version}";
      hash = "sha256-OYh61/83yv+ycivylfdS8yFUIUAk8euAPvmfjPzldGs=";
    };

    # On update, it can be useful to steal the changes from gentoo
    # https://gitweb.gentoo.org/repo/gentoo.git/tree/sci-libs/tensorflow

    nativeBuildInputs = [
      which pythonEnv cython perl protobuf-core
    ] ++ lib.optional cudaSupport addOpenGLRunpath;

    buildInputs = [
      jemalloc
      mpi
      glibcLocales
      git

      # libs taken from system through the TF_SYS_LIBS mechanism
      boringssl
      curl
      double-conversion
      flatbuffers-core
      giflib
      grpc
      icu
      jsoncpp
      libjpeg_turbo
      libpng
      lmdb-core
      pybind11
      snappy
      sqlite
    ] ++ lib.optionals cudaSupport [
      cudatoolkit
      cudnn
    ] ++ lib.optionals mklSupport [
      mkl
    ] ++ lib.optionals stdenv.isDarwin [
      Foundation
      Security
    ] ++ lib.optionals (!stdenv.isDarwin) [
      nsync
    ];

    # arbitrarily set to the current latest bazel version, overly careful
    TF_IGNORE_MAX_BAZEL_VERSION = true;

    LIBTOOL = lib.optionalString stdenv.isDarwin "${cctools}/bin/libtool";

    # Take as many libraries from the system as possible. Keep in sync with
    # list of valid syslibs in
    # https://github.com/tensorflow/tensorflow/blob/master/third_party/systemlibs/syslibs_configure.bzl
    TF_SYSTEM_LIBS = lib.concatStringsSep "," ([
      "absl_py"
      "astor_archive"
      "astunparse_archive"
      "boringssl"
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
      "lmdb"
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
    ] ++ lib.optionals (!stdenv.isDarwin) [
      "nsync" # fails to build on darwin
    ]);

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
    TF_CUDA_PATHS = lib.optionalString cudaSupport "${cudatoolkit_joined},${cudnn},${nccl}";
    GCC_HOST_COMPILER_PREFIX = lib.optionalString cudaSupport "${cudatoolkit_cc_joined}/bin";
    GCC_HOST_COMPILER_PATH = lib.optionalString cudaSupport "${cudatoolkit_cc_joined}/bin/gcc";
    TF_CUDA_COMPUTE_CAPABILITIES = builtins.concatStringsSep "," cudaFlags.cudaRealArchs;

    postPatch = ''
      # bazel 3.3 should work just as well as bazel 3.1
      rm -f .bazelversion
      patchShebangs .
    '' + lib.optionalString (stdenv.hostPlatform.system == "x86_64-darwin") ''
      cat ${./com_google_absl_fix_macos.patch} >> third_party/absl/com_google_absl_fix_mac_and_nvcc_build.patch
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
    ++ lib.optionals stdenv.cc.isClang [
      "--cxxopt=-x" "--cxxopt=c++"
      "--host_cxxopt=-x" "--host_cxxopt=c++"

      # workaround for https://github.com/bazelbuild/bazel/issues/15359
      "--spawn_strategy=sandboxed"
    ]
    ++ lib.optionals (mklSupport) [ "--config=mkl" ];

    bazelTarget = "//tensorflow/tools/pip_package:build_pip_package //tensorflow/tools/lib_package:libtensorflow";

    removeRulesCC = false;
    # Without this Bazel complaints about sandbox violations.
    dontAddBazelOpts = true;

    fetchAttrs = {
      sha256 = {
      x86_64-linux = if cudaSupport
        then "sha256-/wB9EpaDPg3TrD9qggdA4vPgzvmaKc6dDnLjoYTJC5o="
        else "sha256-QgOaUaq0V5HG9BOv9nEw8OTSlzINNFvbnyP8Vx+r9Xw=";
      aarch64-linux = "sha256-zjnRtTG1j9cZTbP0Xnk2o/zWTNsP8T0n4Ai8IiAT3PE=";
      x86_64-darwin = "sha256-RBLox9rzBKcZMm4NwnT7vQ/EjapWQJkqxuQ0LIdaM1E=";
      aarch64-darwin = "sha256-BRzh79lYvMHsUMk8BEYDLHTpnmeZ9+0lrDtj4XI1YY4=";
      }.${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}");
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
      changelog = "https://github.com/tensorflow/tensorflow/releases/tag/v${version}";
      description = "Computation using data flow graphs for scalable machine learning";
      homepage = "http://tensorflow.org";
      license = licenses.asl20;
      maintainers = with maintainers; [ jyp abbradar ];
      platforms = with platforms; linux ++ darwin;
      broken = !(xlaSupport -> cudaSupport);
    } // lib.optionalAttrs stdenv.isDarwin {
      timeout = 86400; # 24 hours
      maxSilent = 14400; # 4h, double the default of 7200s
    };
  };

in buildPythonPackage {
  inherit version pname;
  disabled = !isPy3k;

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
  ] ++ lib.optionals withTensorboard [
    tensorboard
  ];

  # remove patchelfUnstable once patchelf 0.14 with https://github.com/NixOS/patchelf/pull/256 becomes the default
  nativeBuildInputs = lib.optionals cudaSupport [ addOpenGLRunpath patchelfUnstable ];

  postFixup = lib.optionalString cudaSupport ''
    find $out -type f \( -name '*.so' -or -name '*.so.*' \) | while read lib; do
      addOpenGLRunpath "$lib"

      patchelf --set-rpath "${cudatoolkit}/lib:${cudatoolkit.lib}/lib:${cudnn}/lib:${nccl}/lib:$(patchelf --print-rpath "$lib")" "$lib"
    done
  '';

  # Actual tests are slow and impure.
  # TODO try to run them anyway
  # TODO better test (files in tensorflow/tools/ci_build/builds/*test)
  # TEST_PACKAGES in tensorflow/tools/pip_package/setup.py
  nativeCheckInputs = [
    dill
    keras
    portpicker
    tblib
  ];
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
    inherit cudaPackages;
    deps = bazel-build.deps;
    libtensorflow = bazel-build.out;
  };

  inherit (bazel-build) meta;
}

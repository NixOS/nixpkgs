{ stdenv, bazel_5, buildBazelPackage, isPy3k, lib, fetchFromGitHub, symlinkJoin
, addOpenGLRunpath, fetchpatch, patchelfUnstable
# Python deps
, buildPythonPackage, pythonOlder, python
# Python libraries
, numpy, tensorboard, absl-py
, packaging, setuptools, wheel, keras, keras-preprocessing, google-pasta
, opt-einsum, astunparse, h5py
, termcolor, grpcio, six, wrapt, protobuf-python, tensorflow-estimator
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
# Default from ./configure script
, cudaCapabilities ? [ "sm_35" "sm_50" "sm_60" "sm_70" "sm_75" "compute_80" ]
, sse42Support ? stdenv.hostPlatform.sse4_2Support
, avx2Support  ? stdenv.hostPlatform.avx2Support
, fmaSupport   ? stdenv.hostPlatform.fmaSupport
# Darwin deps
, Foundation, Security, cctools, llvmPackages_11
}:

let
  inherit (cudaPackages) cudatoolkit cudnn nccl;
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

  version = "2.10.1";
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
      tensorflow-estimator
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
      rev = "v${version}";
      hash = "sha256-AYHUtJEXYZdVDigKZo7mQnV+PDeQg8mi45YH18qXHZA=";
    };

    patches = [
      (fetchpatch {
        name = "CVE-2023-27579.patch";
        url = "https://github.com/tensorflow/tensorflow/commit/34f8368c535253f5c9cb3a303297743b62442aaa.patch";
        sha256 = "sha256-oGTTRdELzK2hqcnCJD+9CqKNT0CnxHrXvr5n4V+dNNE=";
      })
      (fetchpatch {
        name = "CVE-2023-25801.patch";
        url = "https://github.com/tensorflow/tensorflow/commit/ee50d1e00f81f62a4517453f721c634bbb478307.patch";
        sha256 = "sha256-OnaVG4xjnpX8NShVDsyUCxt/IUym4jh8pUyObxATIhA=";
      })
      (fetchpatch {
        name = "CVE-2023-25676.patch";
        url = "https://github.com/tensorflow/tensorflow/commit/da66bc6d5ff466aee084f9e7397980a24890cd15.patch";
        sha256 = "sha256-U0j6qVCopTUIqoZgbEdBhIr3kgqqC1gJM6AJo08ycfs=";
      })
      ./2.10.1-CVE-2023-25675.patch
      (fetchpatch {
        name = "CVE-2023-25673.CVE-2023-25674.patch";
        url = "https://github.com/tensorflow/tensorflow/commit/728113a3be690facad6ce436660a0bc1858017fa.patch";
        sha256 = "sha256-b8PzCdLVNgHJ59z0qmet+X5Ta8WgO7xYZUAIuInncBE=";
      })
      (fetchpatch {
        name = "CVE-2023-25671.part-1.patch";
        url = "https://github.com/tensorflow/tensorflow/commit/760322a71ac9033e122ef1f4b1c62813021e5938.patch";
        sha256 = "sha256-ClYGmQbYRwsDb3ng2Dmx+ajNeSLnajEkw11I6P2CyqM=";
      })
      (fetchpatch {
        name = "CVE-2023-25671.part-2.patch";
        url = "https://github.com/tensorflow/tensorflow/commit/2eedc8f676d2c3b8be9492e547b2bc814c10b367.patch";
        sha256 = "sha256-C/4EKC471hJvWt9zmHGEKDHE9rPbK6IvqpyfeOuUREk=";
      })
      (fetchpatch {
        name = "CVE-2023-25670.patch";
        url = "https://github.com/tensorflow/tensorflow/commit/8a47a39d9697969206d23a523c977238717e8727.patch";
        sha256 = "sha256-usCKeytvLNhcFk5HM6ktbWp1JFYuXfRBrTgsM4yLNC8=";
      })
      ./2.10.1-CVE-2023-25669.patch
      # 2.10.1 already addressed CVE-2023-25668 in
      # https://github.com/tensorflow/tensorflow/commit/1c2e7f425529ce166f597b512e3bf524f34cda1a
      (fetchpatch {
        name = "CVE-2023-25667.patch";
        url = "https://github.com/tensorflow/tensorflow/commit/8dc723fcdd1a6127d6c970bd2ecb18b019a1a58d.patch";
        sha256 = "sha256-U6M/Giz7x9jnMP3OuZPd8YidfsGqEdz2ki2XAVRN3Ew=";
      })
      (fetchpatch {
        name = "CVE-2023-25665.patch";
        url = "https://github.com/tensorflow/tensorflow/commit/5e0ecfb42f5f65629fd7a4edd6c4afe7ff0feb04.patch";
        sha256 = "sha256-zAPsSZisrPs951UnXuWYiCjy7ehRuDdMRUevwVcrr0Q=";
      })
      (fetchpatch {
        name = "CVE-2023-25666.patch";
        url = "https://github.com/tensorflow/tensorflow/commit/d0d4e779da0d0f56499c6fa5ba09f0a576cc6b14.patch";
        sha256 = "sha256-0K35pWWQ9Wy2wqur4vtWoOwOCokJxdbxGayIJjEuqAg=";
      })
      (fetchpatch {
        name = "CVE-2023-25664.patch";
        url = "https://github.com/tensorflow/tensorflow/commit/ddaac2bdd099bec5d7923dea45276a7558217e5b.patch";
        sha256 = "sha256-AcJPp6akNMt8wPb/lf18Km1n8V0WnKSppT7udSQLDXw=";
      })
      (fetchpatch {
        name = "CVE-2023-25663.patch";
        url = "https://github.com/tensorflow/tensorflow/commit/239139d2ae6a81ae9ba499ad78b56d9b2931538a.patch";
        sha256 = "sha256-qitBX8pSLCWov1zg+FpVQcFfzzS6crJFkBYUzeA/Ovc=";
      })
      (fetchpatch {
        name = "CVE-2023-25662.patch";
        url = "https://github.com/tensorflow/tensorflow/commit/08b8e18643d6dcde00890733b270ff8d9960c56c.patch";
        sha256 = "sha256-dbukV9dTnp/eIcpqnrrrUtWlHX2WUOQtrN5wdXKy2cc=";
      })
      (fetchpatch {
        name = "CVE-2023-25660.patch";
        url = "https://github.com/tensorflow/tensorflow/commit/6d423b8bcc9aa9f5554dc988c1c16d038b508df1.patch";
        sha256 = "sha256-Nys2HtI4jcngSEm/T9/H5yy6DcdsSr9rNj4pnBkwV7Y=";
      })
      (fetchpatch {
        name = "CVE-2023-25659.patch";
        url = "https://github.com/tensorflow/tensorflow/commit/ee004b18b976eeb5a758020af8880236cd707d05.patch";
        sha256 = "sha256-dxxvK4vqCnk025nTwAiLt2mOgHOX6WHvidAl1GdHahA=";
      })
      (fetchpatch {
        name = "CVE-2023-25658.patch";
        # this is the more minimal fix applied to 2.11.1 as opposed to the large
        # squashed commit indicated in the CVE announcement
        url = "https://github.com/tensorflow/tensorflow/commit/73ed953f5171bade7a32fdcc331ff640c4ed099e.patch";
        sha256 = "sha256-+e0SlrQj/Z+6zNnvnj5TRiPglm4C5BB14r4rFVINCDE=";
      })
    ];

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
    TF_CUDA_COMPUTE_CAPABILITIES = lib.concatStringsSep "," cudaCapabilities;

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
        then "sha256-SudzMTxfifKJJso6haCgOD2dXeAhYSXHA2nzq1ErTHg="
        else "sha256-bwZwK24DlUevN5gIdKmBkq1dJpn0i2H4hq+IN77BzjE=";
      aarch64-linux = "sha256-ZbCNZSHF9of+KGTNEqFdKQ44MVNto/rTyo2XEsKXISg=";
      x86_64-darwin = "sha256-ZfZQjLdqo8VVlfKfkdolvSHQvKe4IbQSLc/4cNzHr3E=";
      aarch64-darwin = "sha256-u+ODHAZDlGe06PUWId4sNKyl60vhAPMd01jMm2EvN8E=";
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
  # - Relax flatbuffers and gast version requirements
  # - The purpose of python3Packages.libclang is not clear at the moment and we don't have it packaged yet
  # - keras and tensorlow-io-gcs-filesystem will be considered as optional for now.
  postPatch = ''
    sed -i setup.py \
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
    tensorflow-estimator
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
  checkInputs = [
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

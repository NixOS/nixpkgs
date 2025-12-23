{
  lib,
  stdenv,
  buildPythonPackage,
  fetchurl,

  # buildInputs
  llvmPackages,

  # build-system
  distutils,

  # dependencies
  ml-dtypes,
  absl-py,
  astunparse,
  flatbuffers,
  gast,
  google-pasta,
  grpcio,
  h5py,
  libclang,
  numpy,
  opt-einsum,
  packaging,
  protobuf,
  requests,
  six,
  tensorboard,
  termcolor,
  typing-extensions,
  wrapt,
  isPy3k,
  mock,

  config,
  cudaSupport ? config.cudaSupport,
  cudaPackages,
  zlib,
  python,
  addDriverRunpath,
}:

# We keep this binary build for three reasons:
# - the source build doesn't work on Darwin.
# - the source build is currently brittle and not easy to maintain
# - the source build doesn't work on NVIDIA Jetson platforms

let
  packages = import ./binary-hashes.nix;
  inherit (cudaPackages) cudatoolkit cudnn;

  isCudaJetson = cudaSupport && cudaPackages.flags.isJetsonBuild;
in
buildPythonPackage rec {
  pname = "tensorflow" + lib.optionalString cudaSupport "-gpu";
  version = packages."${"version" + lib.optionalString isCudaJetson "_jetson"}";
  format = "wheel";

  src =
    let
      pyVerNoDot = lib.strings.stringAsChars (x: lib.optionalString (x != ".") x) python.pythonVersion;
      platform = stdenv.system;
      cuda = lib.optionalString cudaSupport (if isCudaJetson then "_jetson" else "_gpu");
      key = "${platform}_${pyVerNoDot}${cuda}";
    in
    fetchurl (packages.${key} or (throw "tensorflow-bin: unsupported configuration: ${key}"));

  buildInputs = [ llvmPackages.openmp ];

  build-system = [
    distutils
  ];

  nativeBuildInputs =
    lib.optionals cudaSupport [ addDriverRunpath ]
    ++ lib.optionals isCudaJetson [ cudaPackages.autoAddCudaCompatRunpath ];

  dependencies = [
    absl-py
    astunparse
    flatbuffers
    gast
    google-pasta
    grpcio
    h5py
    libclang
    ml-dtypes
    numpy
    opt-einsum
    packaging
    protobuf
    requests
    six
    tensorboard
    termcolor
    typing-extensions
    wrapt
  ]
  ++ lib.optional (!isPy3k) mock;

  preConfigure = ''
    unset SOURCE_DATE_EPOCH

    # Make sure that dist and the wheel file are writable.
    chmod u+rwx -R ./dist

    pushd dist

    for f in tensorflow-*+nv*.whl; do
      # e.g. *nv24.07* -> *nv24.7*
      mv "$f" "$(sed -E 's/(nv[0-9]+)\.0*([0-9]+)/\1.\2/' <<< "$f")"
    done

    popd
  '';

  postFixup =
    # When using the cpu-only wheel, the final package will be named `tensorflow_cpu`.
    # Then, in each package requiring `tensorflow`, our pythonRuntimeDepsCheck will fail with:
    # importlib.metadata.PackageNotFoundError: No package metadata was found for tensorflow
    # Hence, we manually rename the package to `tensorflow`.
    lib.optionalString ((builtins.match ".*tensorflow_cpu.*" src.url) != null) ''
      (
        cd $out/${python.sitePackages}

        dest="tensorflow-${version}.dist-info"

        mv tensorflow_cpu-${version}.dist-info "$dest"

        (
          cd "$dest"

          substituteInPlace METADATA \
            --replace-fail "tensorflow_cpu" "tensorflow"
          substituteInPlace RECORD \
            --replace-fail "tensorflow_cpu" "tensorflow"
        )
      )
    ''
    # Note that we need to run *after* the fixup phase because the
    # libraries are loaded at runtime. If we run in preFixup then
    # patchelf --shrink-rpath will remove the cuda libraries.
    + (
      let
        # rpaths we only need to add if CUDA is enabled.
        cudapaths = lib.optionals cudaSupport [
          cudatoolkit.out
          cudatoolkit.lib
          cudnn
        ];

        libpaths = [
          (lib.getLib stdenv.cc.cc)
          zlib
        ];

        rpath = lib.makeLibraryPath (libpaths ++ cudapaths);
      in
      lib.optionalString stdenv.hostPlatform.isLinux ''
        # This is an array containing all the directories in the tensorflow2
        # package that contain .so files.
        #
        # TODO: Create this list programmatically, and remove paths that aren't
        # actually needed.
        rrPathArr=(
          "$out/${python.sitePackages}/tensorflow/"
          "$out/${python.sitePackages}/tensorflow/core/kernels"
          "$out/${python.sitePackages}/tensorflow/compiler/mlir/stablehlo/"
          "$out/${python.sitePackages}/tensorflow/compiler/tf2tensorrt/"
          "$out/${python.sitePackages}/tensorflow/compiler/tf2xla/ops/"
          "$out/${python.sitePackages}/tensorflow/include/external/ml_dtypes/"
          "$out/${python.sitePackages}/tensorflow/lite/experimental/microfrontend/python/ops/"
          "$out/${python.sitePackages}/tensorflow/lite/python/analyzer_wrapper/"
          "$out/${python.sitePackages}/tensorflow/lite/python/interpreter_wrapper/"
          "$out/${python.sitePackages}/tensorflow/lite/python/metrics/"
          "$out/${python.sitePackages}/tensorflow/lite/python/optimize/"
          "$out/${python.sitePackages}/tensorflow/python/"
          "$out/${python.sitePackages}/tensorflow/python/autograph/impl/testing"
          "$out/${python.sitePackages}/tensorflow/python/client"
          "$out/${python.sitePackages}/tensorflow/python/data/experimental/service"
          "$out/${python.sitePackages}/tensorflow/python/framework"
          "$out/${python.sitePackages}/tensorflow/python/grappler"
          "$out/${python.sitePackages}/tensorflow/python/lib/core"
          "$out/${python.sitePackages}/tensorflow/python/lib/io"
          "$out/${python.sitePackages}/tensorflow/python/platform"
          "$out/${python.sitePackages}/tensorflow/python/profiler/internal"
          "$out/${python.sitePackages}/tensorflow/python/saved_model"
          "$out/${python.sitePackages}/tensorflow/python/util"
          "$out/${python.sitePackages}/tensorflow/tsl/python/lib/core"
          "$out/${python.sitePackages}/tensorflow.libs/"
          "${rpath}"
        )

        # The the bash array into a colon-separated list of RPATHs.
        rrPath=$(IFS=$':'; echo "''${rrPathArr[*]}")
        echo "about to run patchelf with the following rpath: $rrPath"

        find $out -type f \( -name '*.so' -or -name '*.so.*' \) | while read lib; do
          echo "about to patchelf $lib..."
          chmod a+rx "$lib"
          patchelf --set-rpath "$rrPath" "$lib"
          ${lib.optionalString cudaSupport ''
            addDriverRunpath "$lib"
          ''}
        done
      ''
    )
    # Symlink nvcc besides TensorFlow so that routines that require JIT can work
    # properly.
    + lib.optionalString cudaSupport ''
      ln -s ${cudaPackages.cuda_nvcc} "$out/${python.sitePackages}/tensorflow/cuda"
    '';

  # Upstream has a pip hack that results in bin/tensorboard being in both tensorflow
  # and the propagated input tensorboard, which causes environment collisions.
  # Another possibility would be to have tensorboard only in the buildInputs
  # See https://github.com/NixOS/nixpkgs/pull/44381 for more information.
  postInstall = ''
    rm $out/bin/tensorboard
  '';

  pythonImportsCheck = [
    "tensorflow"
    "tensorflow.python"
    "tensorflow.python.framework"
  ];

  meta = {
    description = "Computation using data flow graphs for scalable machine learning";
    homepage = "http://tensorflow.org";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.asl20;
    maintainers = [ ];
    badPlatforms = [ "x86_64-darwin" ];
    # unsupported combination
    broken = stdenv.hostPlatform.isDarwin && cudaSupport;
  };
}

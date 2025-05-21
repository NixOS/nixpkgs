{
  stdenv,
  lib,
  fetchurl,
  buildPythonPackage,
  isPy3k,
  astor,
  gast,
  google-pasta,
  wrapt,
  numpy,
  six,
  termcolor,
  packaging,
  protobuf,
  absl-py,
  grpcio,
  mock,
  scipy,
  distutils,
  wheel,
  jax,
  ml-dtypes,
  opt-einsum,
  tensorflow-estimator-bin,
  tensorboard,
  config,
  cudaSupport ? config.cudaSupport,
  cudaPackages,
  zlib,
  python,
  keras-applications,
  keras-preprocessing,
  addDriverRunpath,
  astunparse,
  flatbuffers,
  h5py,
  llvmPackages,
  typing-extensions,
}:

# We keep this binary build for three reasons:
# - the source build doesn't work on Darwin.
# - the source build is currently brittle and not easy to maintain
# - the source build doesn't work on NVIDIA Jetson platforms

# unsupported combination
assert !(stdenv.isDarwin && cudaSupport);

let
  packages = import ./binary-hashes.nix;
  inherit (cudaPackages) cudatoolkit cudnn;

  isCudaJetson = cudaSupport && cudaPackages.cudaFlags.isJetsonBuild;
  isCudaX64 = cudaSupport && stdenv.hostPlatform.isx86_64;
in
buildPythonPackage {
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
    fetchurl (packages.${key} or (throw "tensoflow-bin: unsupported configuration: ${key}"));

  buildInputs = [ llvmPackages.openmp ];

  dependencies = [
    astunparse
    flatbuffers
    typing-extensions
    packaging
    protobuf
    numpy
    scipy
    (if isCudaX64 then jax else ml-dtypes)
    termcolor
    grpcio
    six
    astor
    absl-py
    gast
    opt-einsum
    google-pasta
    wrapt
    tensorflow-estimator-bin
    tensorboard
    keras-applications
    keras-preprocessing
    h5py
  ] ++ lib.optional (!isPy3k) mock;

  build-system =
    [
      distutils
      wheel
    ]
    ++ lib.optionals cudaSupport [ addDriverRunpath ]
    ++ lib.optionals isCudaJetson [ cudaPackages.autoAddCudaCompatRunpath ];

  preConfigure = ''
    unset SOURCE_DATE_EPOCH

    # Make sure that dist and the wheel file are writable.
    chmod u+rwx -R ./dist

    pushd dist

    for f in tensorflow-*+nv*.whl; do
      # e.g. *nv24.07* -> *nv24.7*
      mv "$f" "$(sed -E 's/(nv[0-9]+)\.0*([0-9]+)/\1.\2/' <<< "$f")"
    done

    wheel unpack --dest unpacked ./*.whl
    rm ./*.whl
    (
      cd unpacked/tensorflow*
      # Adjust dependency requirements:
      # - Relax flatbuffers, gast, protobuf, tensorboard, and tensorflow-estimator version requirements that don't match what we have packaged
      # - The purpose of python3Packages.libclang is not clear at the moment and we don't have it packaged yet
      # - keras and tensorlow-io-gcs-filesystem will be considered as optional for now.
      # - numpy was pinned to fix some internal tests: https://github.com/tensorflow/tensorflow/issues/60216
      sed -i *.dist-info/METADATA \
        -e "/Requires-Dist: flatbuffers/d" \
        -e "/Requires-Dist: gast/d" \
        -e "/Requires-Dist: keras/d" \
        -e "/Requires-Dist: libclang/d" \
        -e "/Requires-Dist: protobuf/d" \
        -e "/Requires-Dist: tensorboard/d" \
        -e "/Requires-Dist: tensorflow-estimator/d" \
        -e "/Requires-Dist: tensorflow-io-gcs-filesystem/d" \
        -e "s/Requires-Dist: numpy (.*)/Requires-Dist: numpy/"
    )
    wheel pack ./unpacked/tensorflow*

    popd
  '';

  # Note that we need to run *after* the fixup phase because the
  # libraries are loaded at runtime. If we run in preFixup then
  # patchelf --shrink-rpath will remove the cuda libraries.
  postFixup =
    let
      # rpaths we only need to add if CUDA is enabled.
      cudapaths = lib.optionals cudaSupport [
        cudatoolkit.out
        cudatoolkit.lib
        cudnn
      ];

      libpaths = [
        stdenv.cc.cc.lib
        zlib
      ];

      rpath = lib.makeLibraryPath (libpaths ++ cudapaths);
    in
    lib.optionalString stdenv.isLinux ''
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
    maintainers = with lib.maintainers; [
      jyp
      abbradar
    ];
    badPlatforms = [ "x86_64-darwin" ];
  };
}

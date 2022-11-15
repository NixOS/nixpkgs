{ stdenv
, lib
, fetchurl
, buildPythonPackage
, isPy3k, pythonOlder, pythonAtLeast, astor
, gast
, google-pasta
, wrapt
, numpy
, six
, termcolor
, packaging
, protobuf
, absl-py
, grpcio
, mock
, scipy
, wheel
, opt-einsum
, backports_weakref
, tensorflow-estimator
, tensorboard
, cudaSupport ? false
, cudaPackages ? {}
, patchelfUnstable
, zlib
, python
, keras-applications
, keras-preprocessing
, addOpenGLRunpath
, astunparse
, flatbuffers
, h5py
, typing-extensions
}:

# We keep this binary build for two reasons:
# - the source build doesn't work on Darwin.
# - the source build is currently brittle and not easy to maintain

# unsupported combination
assert ! (stdenv.isDarwin && cudaSupport);

let
  packages = import ./binary-hashes.nix;
  inherit (cudaPackages) cudatoolkit cudnn;
in buildPythonPackage {
  pname = "tensorflow" + lib.optionalString cudaSupport "-gpu";
  inherit (packages) version;
  format = "wheel";

  src = let
    pyVerNoDot = lib.strings.stringAsChars (x: if x == "." then "" else x) python.pythonVersion;
    platform = if stdenv.isDarwin then "mac" else "linux";
    unit = if cudaSupport then "gpu" else "cpu";
    key = "${platform}_py_${pyVerNoDot}_${unit}";
  in fetchurl packages.${key};

  propagatedBuildInputs = [
    astunparse
    flatbuffers
    typing-extensions
    packaging
    protobuf
    numpy
    scipy
    termcolor
    grpcio
    six
    astor
    absl-py
    gast
    opt-einsum
    google-pasta
    wrapt
    tensorflow-estimator
    tensorboard
    keras-applications
    keras-preprocessing
    h5py
  ] ++ lib.optional (!isPy3k) mock
    ++ lib.optionals (pythonOlder "3.4") [ backports_weakref ];

  # remove patchelfUnstable once patchelf 0.14 with https://github.com/NixOS/patchelf/pull/256 becomes the default
  nativeBuildInputs = [ wheel ] ++ lib.optionals cudaSupport [ addOpenGLRunpath patchelfUnstable ];

  preConfigure = ''
    unset SOURCE_DATE_EPOCH

    # Make sure that dist and the wheel file are writable.
    chmod u+rwx -R ./dist

    pushd dist

    orig_name="$(echo ./*.whl)"
    wheel unpack --dest unpacked ./*.whl
    rm ./*.whl
    (
      cd unpacked/tensorflow*
      # Adjust dependency requirements:
      # - Relax flatbuffers, gast, protobuf, tensorboard, and tensorflow-estimator version requirements that don't match what we have packaged
      # - The purpose of python3Packages.libclang is not clear at the moment and we don't have it packaged yet
      # - keras and tensorlow-io-gcs-filesystem will be considered as optional for now.
      sed -i *.dist-info/METADATA \
        -e "/Requires-Dist: flatbuffers/d" \
        -e "/Requires-Dist: gast/d" \
        -e "/Requires-Dist: keras/d" \
        -e "/Requires-Dist: libclang/d" \
        -e "/Requires-Dist: protobuf/d" \
        -e "/Requires-Dist: tensorboard/d" \
        -e "/Requires-Dist: tensorflow-estimator/d" \
        -e "/Requires-Dist: tensorflow-io-gcs-filesystem/d"
    )
    wheel pack ./unpacked/tensorflow*
    mv *.whl $orig_name # avoid changes to the _os_arch.whl suffix

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
        "$out/${python.sitePackages}/tensorflow/compiler/tf2tensorrt/"
        "$out/${python.sitePackages}/tensorflow/compiler/tf2xla/ops/"
        "$out/${python.sitePackages}/tensorflow/lite/experimental/microfrontend/python/ops/"
        "$out/${python.sitePackages}/tensorflow/lite/python/interpreter_wrapper/"
        "$out/${python.sitePackages}/tensorflow/lite/python/optimize/"
        "$out/${python.sitePackages}/tensorflow/python/"
        "$out/${python.sitePackages}/tensorflow/python/framework/"
        "$out/${python.sitePackages}/tensorflow/python/autograph/impl/testing"
        "$out/${python.sitePackages}/tensorflow/python/data/experimental/service"
        "$out/${python.sitePackages}/tensorflow/python/framework"
        "$out/${python.sitePackages}/tensorflow/python/profiler/internal"
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
          addOpenGLRunpath "$lib"
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

  passthru = {
    inherit cudaPackages;
  };

  meta = with lib; {
    description = "Computation using data flow graphs for scalable machine learning";
    homepage = "http://tensorflow.org";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.asl20;
    maintainers = with maintainers; [ jyp abbradar cdepillabout ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}

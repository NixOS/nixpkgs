{ stdenv
, lib
, fetchurl
, buildPythonPackage
, isPy3k, pythonOlder, isPy38
, astor
, gast
, google-pasta
, wrapt
, numpy
, six
, termcolor
, protobuf
, absl-py
, grpcio
, mock
, scipy
, wheel
, opt-einsum
, backports_weakref
, tensorflow-estimator
, tensorflow-tensorboard
, cudaSupport ? false
, cudatoolkit ? null
, cudnn ? null
, nvidia_x11 ? null
, zlib
, python
, symlinkJoin
, keras-applications
, keras-preprocessing
, addOpenGLRunpath
}:

# We keep this binary build for two reasons:
# - the source build doesn't work on Darwin.
# - the source build is currently brittle and not easy to maintain

assert cudaSupport -> cudatoolkit != null
                   && cudnn != null
                   && nvidia_x11 != null;

# unsupported combination
assert ! (stdenv.isDarwin && cudaSupport);

let
  packages = import ./binary-hashes.nix;

  variant = if cudaSupport then "-gpu" else "";
  pname = "tensorflow${variant}";

in buildPythonPackage {
  inherit pname;
  inherit (packages) version;
  format = "wheel";

  disabled = isPy38;

  src = let
    pyVerNoDot = lib.strings.stringAsChars (x: if x == "." then "" else x) python.pythonVersion;
    platform = if stdenv.isDarwin then "mac" else "linux";
    unit = if cudaSupport then "gpu" else "cpu";
    key = "${platform}_py_${pyVerNoDot}_${unit}";
  in fetchurl packages.${key};

  propagatedBuildInputs = [
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
    tensorflow-tensorboard
    keras-applications
    keras-preprocessing
  ] ++ lib.optional (!isPy3k) mock
    ++ lib.optionals (pythonOlder "3.4") [ backports_weakref ];

  nativeBuildInputs = [ wheel ] ++ lib.optional cudaSupport addOpenGLRunpath;

  preConfigure = ''
    unset SOURCE_DATE_EPOCH

    # Make sure that dist and the wheel file are writable.
    chmod u+rwx -R ./dist

    pushd dist

    # Unpack the wheel file.
    wheel unpack --dest unpacked ./*.whl

    # Tensorflow has a hard dependency on gast==0.2.2, but we relax it to
    # gast==0.3.2.
    substituteInPlace ./unpacked/tensorflow*/tensorflow_core/tools/pip_package/setup.py --replace "gast == 0.2.2" "gast == 0.3.2"
    substituteInPlace ./unpacked/tensorflow*/tensorflow_*.dist-info/METADATA --replace "gast (==0.2.2)" "gast (==0.3.2)"

    # Pack the wheel file back up.
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
        nvidia_x11
      ];

      libpaths = [
        stdenv.cc.cc.lib
        zlib
      ];

      rpath = stdenv.lib.makeLibraryPath (libpaths ++ cudapaths);
    in
    lib.optionalString stdenv.isLinux ''
      # This is an array containing all the directories in the tensorflow2
      # package that contain .so files.
      #
      # TODO: Create this list programmatically, and remove paths that aren't
      # actually needed.
      rrPathArr=(
        "$out/${python.sitePackages}/tensorflow_core/"
        "$out/${python.sitePackages}/tensorflow_core/compiler/tf2tensorrt/"
        "$out/${python.sitePackages}/tensorflow_core/compiler/tf2xla/ops/"
        "$out/${python.sitePackages}/tensorflow_core/lite/experimental/microfrontend/python/ops/"
        "$out/${python.sitePackages}/tensorflow_core/lite/python/interpreter_wrapper/"
        "$out/${python.sitePackages}/tensorflow_core/lite/python/optimize/"
        "$out/${python.sitePackages}/tensorflow_core/python/"
        "$out/${python.sitePackages}/tensorflow_core/python/framework/"
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

  pythonImportsCheck = [
    "tensorflow"
    "tensorflow.keras"
    "tensorflow.python"
    "tensorflow.python.framework"
  ];

  meta = with stdenv.lib; {
    description = "Computation using data flow graphs for scalable machine learning";
    homepage = http://tensorflow.org;
    license = licenses.asl20;
    maintainers = with maintainers; [ jyp abbradar cdepillabout ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    # Python 2.7 build uses different string encoding.
    # See https://github.com/NixOS/nixpkgs/pull/37044#issuecomment-373452253
    broken = stdenv.isDarwin && !isPy3k;
  };
}

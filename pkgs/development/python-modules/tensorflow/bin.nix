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
    pyver = if stdenv.isDarwin then builtins.substring 0 1 pyVerNoDot else pyVerNoDot;
    platform = if stdenv.isDarwin then "mac" else "linux";
    unit = if cudaSupport then "gpu" else "cpu";
    key = "${platform}_py_${pyver}_${unit}";
  in fetchurl packages.${key};

  propagatedBuildInputs = [
    protobuf
    numpy
    termcolor
    grpcio
    six
    astor
    absl-py
    gast
    google-pasta
    wrapt
    tensorflow-estimator
    tensorflow-tensorboard
    keras-applications
    keras-preprocessing
  ] ++ lib.optional (!isPy3k) mock
    ++ lib.optionals (pythonOlder "3.4") [ backports_weakref ];

  nativeBuildInputs = lib.optional cudaSupport addOpenGLRunpath;

  # Upstream has a pip hack that results in bin/tensorboard being in both tensorflow
  # and the propageted input tensorflow-tensorboard which causes environment collisions.
  # another possibility would be to have tensorboard only in the buildInputs
  # https://github.com/tensorflow/tensorflow/blob/v1.7.1/tensorflow/tools/pip_package/setup.py#L79
  postInstall = ''
    rm $out/bin/tensorboard
  '';

  # Note that we need to run *after* the fixup phase because the
  # libraries are loaded at runtime. If we run in preFixup then
  # patchelf --shrink-rpath will remove the cuda libraries.
  postFixup = let
    rpath = stdenv.lib.makeLibraryPath
      ([ stdenv.cc.cc.lib zlib ] ++ lib.optionals cudaSupport [ cudatoolkit.out cudatoolkit.lib cudnn nvidia_x11 ]);
  in
  lib.optionalString stdenv.isLinux ''
    rrPath="$out/${python.sitePackages}/tensorflow/:$out/${python.sitePackages}/tensorflow/contrib/tensor_forest/:${rpath}"
    internalLibPath="$out/${python.sitePackages}/tensorflow/python/_pywrap_tensorflow_internal.so"
    find $out -type f \( -name '*.so' -or -name '*.so.*' \) | while read lib; do
      patchelf --set-rpath "$rrPath" "$lib"
      ${lib.optionalString cudaSupport ''
        addOpenGLRunpath "$lib"
      ''}
    done
  '';


  meta = with stdenv.lib; {
    description = "Computation using data flow graphs for scalable machine learning";
    homepage = http://tensorflow.org;
    license = licenses.asl20;
    maintainers = with maintainers; [ jyp abbradar ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    # Python 2.7 build uses different string encoding.
    # See https://github.com/NixOS/nixpkgs/pull/37044#issuecomment-373452253
    broken = stdenv.isDarwin && !isPy3k;
  };
}

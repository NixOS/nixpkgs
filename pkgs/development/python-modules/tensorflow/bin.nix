{ stdenv
, lib
, fetchurl
, buildPythonPackage
, isPy3k, isPy35, isPy36, pythonOlder
, numpy
, six
, protobuf
, absl-py
, mock
, backports_weakref
, enum34
, tensorflow-tensorboard
, cudaSupport ? false
, cudatoolkit ? null
, cudnn ? null
, nvidia_x11 ? null
, zlib
, python
, symlinkJoin
}:

# We keep this binary build for two reasons:
# - the source build doesn't work on Darwin.
# - the source build is currently brittle and not easy to maintain

assert cudaSupport -> cudatoolkit != null
                   && cudnn != null
                   && nvidia_x11 != null;
let
  cudatoolkit_joined = symlinkJoin {
    name = "unsplit_cudatoolkit";
    paths = [ cudatoolkit.out
              cudatoolkit.lib ];};

in buildPythonPackage rec {
  pname = "tensorflow";
  version = "1.7.1";
  format = "wheel";

  src = let
    pyVerNoDot = lib.strings.stringAsChars (x: if x == "." then "" else x) "${python.majorVersion}";
    version = if stdenv.isDarwin then builtins.substring 0 1 pyVerNoDot else pyVerNoDot;
    platform = if stdenv.isDarwin then "mac" else "linux";
    unit = if cudaSupport then "gpu" else "cpu";
    key = "${platform}_py_${version}_${unit}";
    dls = import ./tf1.7.1-hashes.nix;
  in fetchurl dls.${key};

  propagatedBuildInputs = [ numpy six protobuf absl-py ]
                 ++ lib.optional (!isPy3k) mock
                 ++ lib.optionals (pythonOlder "3.4") [ backports_weakref enum34 ]
                 ++ lib.optional (pythonOlder "3.6") tensorflow-tensorboard;

  # tensorflow depends on tensorflow_tensorboard, which cannot be
  # built at the moment (some of its dependencies do not build
  # [htlm5lib9999999 (seven nines) -> tensorboard], and it depends on an old version of
  # bleach) Hence we disable dependency checking for now.
  installFlags = lib.optional isPy36 "--no-dependencies";

  # Note that we need to run *after* the fixup phase because the
  # libraries are loaded at runtime. If we run in preFixup then
  # patchelf --shrink-rpath will remove the cuda libraries.
  postFixup = let
    rpath = stdenv.lib.makeLibraryPath
      ([ stdenv.cc.cc.lib zlib ] ++ lib.optionals cudaSupport [ cudatoolkit_joined cudnn nvidia_x11 ]);
  in
  lib.optionalString (stdenv.isLinux) ''
    rrPath="$out/${python.sitePackages}/tensorflow/:${rpath}"
    internalLibPath="$out/${python.sitePackages}/tensorflow/python/_pywrap_tensorflow_internal.so"
    find $out -name '*.${stdenv.hostPlatform.extensions.sharedLibrary}' -exec patchelf --set-rpath "$rrPath" {} \;
  '';


  meta = with stdenv.lib; {
    description = "Computation using data flow graphs for scalable machine learning";
    homepage = http://tensorflow.org;
    license = licenses.asl20;
    maintainers = with maintainers; [ jyp abbradar ];
    platforms = with platforms; linux ++ lib.optionals (!cudaSupport) darwin;
    # Python 2.7 build uses different string encoding.
    # See https://github.com/NixOS/nixpkgs/pull/37044#issuecomment-373452253
    broken = stdenv.isDarwin && !isPy3k;
  };
}

{ stdenv
, symlinkJoin
, lib
, fetchurl
, python
, buildPythonPackage
, isPy3k, isPy35, isPy36, isPy27
, cudaSupport ? false
, nvidia_x11 ? null
, cudatoolkit ? null
, cudnn ? null
, linuxPackages ? null
, tensorflow-tensorboard
, six
, protobuf
, numpy
, mock
, backports_weakref
, absl-py
, zlib
}:

assert cudaSupport -> cudatoolkit != null
                   && cudnn != null
                   && linuxPackages != null;

# unsupported combination
assert ! (stdenv.isDarwin && cudaSupport);

# tensorflow is built from a downloaded wheel, because the upstream
# project's build system is an arcane beast based on
# bazel. Untangling it and building the wheel from source is an open
# problem.
let
  # cudatoolkit is split (see https://github.com/NixOS/nixpkgs/commit/bb1c9b027d343f2ce263496582d6b56af8af92e6)
  # However this means that libcusolver is not loadable by tensor flow. So we undo the split here.
  cudatoolkit_joined = symlinkJoin {
    name = "unsplit_cudatoolkit";
    paths = [
      cudatoolkit.out
      cudatoolkit.lib
    ];
   };

in buildPythonPackage rec {
  pname = "tensorflow";
  version = "1.4.1";
  name = "${pname}-${version}";
  format = "wheel";
  disabled = ! (isPy35 || isPy36 || isPy27);


  src = let dls = import ./tf1.4.1-hashes.nix;
    in
    fetchurl (
      if stdenv.isDarwin then
        if isPy3k then
          dls.mac_py_3_cpu
        else
          dls.mac_py_2_cpu
      else
        if isPy35 then
          if cudaSupport then
            dls.linux_py_35_gpu
          else
            dls.linux_py_35_cpu
        else if isPy36 then
          if cudaSupport then
            dls.linux_py_36_gpu
          else
            dls.linux_py_36_cpu
        else
          if cudaSupport then
            dls.linux_py_27_gpu
          else
            dls.linux_py_27_cpu
    );

  propagatedBuildInputs =
    [ numpy six protobuf mock backports_weakref absl-py ]
    ++ lib.optional (!isPy36) tensorflow-tensorboard
    ++ lib.optionals cudaSupport [ cudatoolkit_joined cudnn stdenv.cc ];

  # tensorflow-gpu depends on tensorflow_tensorboard, which cannot be
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
  ''
    rrPath="$out/${python.sitePackages}/tensorflow/:${rpath}"
    internalLibPath="$out/${python.sitePackages}/tensorflow/python/_pywrap_tensorflow_internal.so"
    find $out -name '*.so' -exec patchelf --set-rpath "$rrPath" {} \;
  '';

  doCheck = false;

  meta = with stdenv.lib; {
    description = "TensorFlow helps the tensors flow";
    homepage = http://tensorflow.org;
    license = licenses.asl20;
    maintainers = with maintainers; [ jyp abbradar ];
    platforms = with platforms; if cudaSupport then linux else linux ++ darwin;
  };
}

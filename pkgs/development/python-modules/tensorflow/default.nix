{ stdenv
, lib
, fetchurl
, buildPythonPackage
, isPy3k, isPy35, isPy36, isPy27
, cudaSupport ? false
, cudatoolkit ? null
, cudnn ? null
, linuxPackages ? null
, numpy
, six
, protobuf
, mock
, backports_weakref
, zlib
, tensorflow-tensorboard
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

buildPythonPackage rec {
  pname = "tensorflow";
  version = "1.3.0";
  name = "${pname}-${version}";
  format = "wheel";
  disabled = ! (isPy35 || isPy36 || isPy27);

  src = let
      tfurl = sys: proc: pykind:
        let
          tfpref = if proc == "gpu"
            then "gpu/tensorflow_gpu"
            else "cpu/tensorflow";
        in
        "https://storage.googleapis.com/tensorflow/${sys}/${tfpref}-${version}-${pykind}.whl";
      dls =
        {
        darwin.cpu = {
          py2 = {
            url = tfurl "mac" "cpu" "py2-none-any" ;
            sha256 = "0nkymqbqjx8rsmc8vkc26cfsg4hpr6lj9zrwhjnfizvkzbbsh5z4";
          };
          py3 = {
            url = tfurl "mac" "cpu" "py3-none-any" ;
            sha256 = "1rj4m817w3lajnb1lgn3bwfwwk3qwvypyx11dim1ybakbmsc1j20";
          };
        };
        linux-x86_64.cpu = {
          py2 = {
            url = tfurl "linux" "cpu" "cp27-none-linux_x86_64";
            sha256 = "09pcyx0yfil4dm6cij8n3907pfgva07a38avrbai4qk5h6hxm8w9";
          };
          py35 = {
            url = tfurl "linux" "cpu" "cp35-cp35m-linux_x86_64";
            sha256 = "0p10zcf41pi33bi025fibqkq9rpd3v0rrbdmc9i9yd7igy076a07";
          };
          py36 = {
            url = tfurl "linux" "cpu" "cp36-cp36m-linux_x86_64";
            sha256 = "1qm8lm2f6bf9d462ybgwrz0dn9i6cnisgwdvyq9ssmy2f1gp8hxk";
          };
        };
        linux-x86_64.cuda = {
          py2 = {
            url = tfurl "linux" "gpu" "cp27-none-linux_x86_64";
            sha256 = "10yyyn4g2fsv1xgmw99bbr0fg7jvykay4gb5pxrrylh7h38h6wah";
          };
          py35 = {
            url = tfurl "linux" "gpu" "cp35-cp35m-linux_x86_64";
            sha256 = "0icwnhkcf3fxr6bmbihqzipnn4pxybd06qv7l3k0p4xdgycwzmzk";
          };
          py36 = {
            url = tfurl "linux" "gpu" "cp36-cp36m-linux_x86_64";
            sha256 = "12g3akkr083gs3sisjbmm0lpsk8phn3dvy7jjfadfxshqc7za14i";
          };
        };
      };
    in
    fetchurl (
      if stdenv.isDarwin then
        if isPy3k then
          dls.darwin.cpu.py3
        else
          dls.darwin.cpu.py2
      else
        if isPy35 then
          if cudaSupport then
            dls.linux-x86_64.cuda.py35
          else
            dls.linux-x86_64.cpu.py35
        else if isPy36 then
          if cudaSupport then
            dls.linux-x86_64.cuda.py36
          else
            dls.linux-x86_64.cpu.py36
        else
          if cudaSupport then
            dls.linux-x86_64.cuda.py2
          else
            dls.linux-x86_64.cpu.py2
    );

  propagatedBuildInputs =
    [ numpy six protobuf mock backports_weakref ]
    ++ lib.optional (!isPy36) tensorflow-tensorboard
    ++ lib.optionals cudaSupport [ cudatoolkit cudnn stdenv.cc ];

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
      (if cudaSupport then
        [ stdenv.cc.cc.lib zlib cudatoolkit cudnn
          linuxPackages.nvidia_x11 ]
      else
        [ stdenv.cc.cc.lib zlib ]
      );
  in
  ''
    find $out -name '*.so' -exec patchelf --set-rpath "${rpath}" {} \;
  '';

  doCheck = false;

  meta = with stdenv.lib; {
    description = "TensorFlow helps the tensors flow";
    homepage = http://tensorflow.org;
    license = licenses.asl20;
    maintainers = with maintainers; [ jyp ];
    platforms = with platforms; if cudaSupport then linux else linux ++ darwin;
  };
}

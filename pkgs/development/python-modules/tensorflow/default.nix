{ stdenv
, fetchurl
, buildPythonPackage
, numpy
, six
, protobuf3_0_0b2
, swig
, mock
, gcc
, zlib
}:

# tensorflow is built from a downloaded wheel, because the upstream
# project's build system is an arcane beast based on
# bazel. Untangling it and building the wheel from source is an open
# problem.

buildPythonPackage rec {
  pname = "tensorflow";
  version = "0.10.0";
  name = "${pname}-${version}";
  format = "wheel";

  src = fetchurl {
    url = if stdenv.isDarwin then
      "https://storage.googleapis.com/tensorflow/mac/cpu/tensorflow-${version}-py2-none-any.whl" else
      "https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-${version}-cp27-none-linux_x86_64.whl";
    sha256 = if stdenv.isDarwin then
      "1gjybh3j3rn34bzhsxsfdbqgsr4jh50qyx2wqywvcb24fkvy40j9" else
      "0g05pa4z6kdy0giz7hjgjgwf4zzr5l8cf1zh247ymixlikn3fnpx";
  };

  propagatedBuildInputs = [ numpy six protobuf3_0_0b2 swig mock];

  preFixup = ''
    RPATH="${stdenv.lib.makeLibraryPath [ gcc.cc.lib zlib ]}"
    find $out -name '*.so' -exec patchelf --set-rpath "$RPATH" {} \;
  '';

  doCheck = false;

  meta = with stdenv.lib; {
    description = "TensorFlow helps the tensors flow (no gpu support)";
    homepage = http://tensorflow.org;
    license = licenses.asl20;
    platforms = with platforms; linux ++ darwin;
  };
}

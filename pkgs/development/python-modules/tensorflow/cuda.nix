{ stdenv
, fetchurl
, buildPythonPackage
, swig
, numpy
, six
, protobuf3_0
, cudatoolkit75
, cudnn5_cudatoolkit75
, gcc49
, zlib
, linuxPackages
, mock
}:

buildPythonPackage rec {
  pname = "tensorflow";
  version = "0.11.0rc0";
  name = "${pname}-${version}";
  format = "wheel";

  src = fetchurl {
    url = "https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow-${version}-cp27-none-linux_x86_64.whl";
    sha256 = "1r8zlz95sw7bnjzg5zdbpa9dj8wmp8cvvgyl9sv3amsscagnnfj5";
  };

  buildInputs = [ swig ];
  propagatedBuildInputs = [ numpy six protobuf3_0 cudatoolkit75 cudnn5_cudatoolkit75 gcc49 mock ];

  # Note that we need to run *after* the fixup phase because the
  # libraries are loaded at runtime. If we run in preFixup then
  # patchelf --shrink-rpath will remove the cuda libraries.
  postFixup = let
    rpath = stdenv.lib.makeLibraryPath [
      gcc49.cc.lib
      zlib cudatoolkit75
      cudnn5_cudatoolkit75
      linuxPackages.nvidia_x11
    ];
  in ''
    find $out -name '*.so' -exec patchelf --set-rpath "${rpath}" {} \;
  '';

  doCheck = false;

  meta = with stdenv.lib; {
    description = "TensorFlow helps the tensors flow (no gpu support)";
    homepage = http://tensorflow.org;
    license = licenses.asl20;
    platforms   = platforms.linux;
  };
}

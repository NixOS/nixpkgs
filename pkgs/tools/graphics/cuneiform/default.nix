{ stdenv, fetchurl, cmake, patchelf, imagemagick }:

stdenv.mkDerivation rec {
  name = "cuneiform-${version}";
  version = "1.1.0";

  src = fetchurl {
    url = "https://launchpad.net/cuneiform-linux/1.1/1.1/+download/cuneiform-linux-1.1.0.tar.bz2";
    sha256 = "1bdvppyfx2184zmzcylskd87cxv56d8f32jf7g1qc8779l2hszjp";
  };

  buildInputs = [
    cmake imagemagick
  ];

  meta = {
    description = "Multi-language OCR system";
    platforms = stdenv.lib.platforms.linux;
  };
}

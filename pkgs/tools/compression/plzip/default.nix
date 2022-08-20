{ lib, stdenv, fetchurl, lzip, lzlib, texinfo }:

stdenv.mkDerivation rec {
  pname = "plzip";
  version = "1.10";
  outputs = [ "out" "man" "info" ];

  nativeBuildInputs = [ lzip texinfo ];
  buildInputs = [ lzlib ];

  src = fetchurl {
    url = "mirror://savannah/lzip/plzip/plzip-${version}.tar.lz";
    sha256 = "62f16a67be0dabf0da7fd1cb7889fe5bfae3140cea6cafa1c39e7e35a5b3c661";
  };

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://www.nongnu.org/lzip/plzip.html";
    description =
      "A massively parallel lossless data compressor based on the lzlib compression library";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ _360ied ];
  };
}

{ lib, stdenv, fetchurl, lzip, lzlib, texinfo }:

stdenv.mkDerivation rec {
  pname = "tarlz";
  version = "0.22";
  outputs = [ "out" "man" "info" ];

  nativeBuildInputs = [ lzip texinfo ];
  buildInputs = [ lzlib ];

  src = fetchurl {
    url = "mirror://savannah/lzip/${pname}/${pname}-${version}.tar.lz";
    sha256 = "sha256-/M9yJvoktV0ybKsT926jSb7ERsWo33GkbTQwmaBQkdw=";
  };

  enableParallelBuilding = true;
  makeFlags = [ "CXX:=$(CXX)" ];
  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    homepage = "https://www.nongnu.org/lzip/${pname}.html";
    description =
      "Massively parallel combined implementation of the tar archiver and the lzip compressor";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ ehmry ];
  };
}

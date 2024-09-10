{ lib
, stdenv
, fetchurl
, libpng
, netpbm
, asciidoctor
}:

stdenv.mkDerivation rec {
  pname = "sng";
  version = "1.1.1";

  src = fetchurl {
    url = "mirror://sourceforge/sng/sng-${version}.tar.xz";
    hash = "sha256-yb37gPWhfbGquTN7rtZKjr6lwN34KRXGiHuM+4fs5h4=";
  };

  nativeBuildInputs = [ asciidoctor ];
  buildInputs = [ libpng ];

  configureFlags = [
    "--with-rgbtxt=${netpbm.out}/share/netpbm/misc/rgb.txt"
  ];
  makeFlags = [ "prefix=${placeholder "out"}" ];

  meta = with lib; {
    description = "Minilanguage designed to represent the entire contents of a PNG file in an editable form";
    homepage = "https://sng.sourceforge.net/";
    license = licenses.zlib;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.unix;
    mainProgram = "sng";
  };
}

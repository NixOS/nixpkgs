{ lib, stdenv, fetchurl, libpng, netpbm }:

stdenv.mkDerivation rec {
  pname = "sng";
  version = "1.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/sng/sng-${version}.tar.gz";
    sha256 = "06a6ydvx9xb3vxvrzdrg3hq0rjwwj9ibr7fyyxjxq6qx1j3mb70i";
  };

  buildInputs = [ libpng ];

  configureFlags = [
    "--with-rgbtxt=${netpbm.out}/share/netpbm/misc/rgb.txt"
  ];

  meta = with lib; {
    description = "Minilanguage designed to represent the entire contents of a PNG file in an editable form";
    homepage = "https://sng.sourceforge.net/";
    license = licenses.zlib;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.unix;
    mainProgram = "sng";
  };
}

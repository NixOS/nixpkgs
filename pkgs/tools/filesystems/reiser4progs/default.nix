{stdenv, fetchurl, libaal}:

let version = "2.0.1"; in
stdenv.mkDerivation rec {
  pname = "reiser4progs";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/reiser4/reiser4-utils/${pname}-${version}.tar.gz";
    sha256 = "1r7m95mnp6xmp1j5k99jhmz6g9y2qq7cghlmdxsfbr3xviqfs45d";
  };

  buildInputs = [libaal];

  hardeningDisable = [ "format" ];

  preConfigure = ''
    substituteInPlace configure --replace " -static" ""
  '';

  preInstall = ''
    substituteInPlace Makefile --replace ./run-ldconfig true
  '';

  meta = with stdenv.lib; {
    inherit version;
    homepage = "https://sourceforge.net/projects/reiser4/";
    description = "Reiser4 utilities";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}

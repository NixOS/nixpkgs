{stdenv, fetchurl, perl, gettext }:

stdenv.mkDerivation rec {
  name = "dos2unix-${version}";
  version = "7.4.0";

  src = fetchurl {
    url = "https://waterlan.home.xs4all.nl/dos2unix/${name}.tar.gz";
    sha256 = "12h4c61g376bhq03y5g2xszkrkrj5hwd928rly3xsp6rvfmnbixs";
  };

  configurePhase = ''
    substituteInPlace Makefile \
    --replace /usr $out
    '';

  buildInputs = [ perl gettext ];

  meta = with stdenv.lib; {
    homepage = http://waterlan.home.xs4all.nl/dos2unix.html;
    description = "Tools to transform text files from dos to unix formats and vicervesa";
    license = licenses.bsd2;
    maintainers = with maintainers; [ndowens ];

  };
}

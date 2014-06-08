{stdenv, fetchurl, perl, gettext }:

stdenv.mkDerivation {
  name = "dos2unix-6.0.5";
  
  src = fetchurl {
    url = http://waterlan.home.xs4all.nl/dos2unix/dos2unix-6.0.5.tar.gz;
    sha256 = "13w5blhv0i473y9lyrxh4axz4niyrxcpj4v2qiq3w5kamyp20czx";
  };

  configurePhase = ''
    sed -i -e s,/usr,$out, Makefile
  '';

  buildInputs = [ perl gettext ];

  meta = {
    homepage = http://waterlan.home.xs4all.nl/dos2unix.html;
    description = "Tools to transform text files from dos to unix formats and vicervesa";
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };
}

{ stdenv, fetchurl, gmp }:

stdenv.mkDerivation rec {
  name = "ssss-0.5";

  src = fetchurl {
    url = http://point-at-infinity.org/ssss/ssss-0.5.tar.gz;
    sha256 = "15grn2fp1x8p92kxkwbmsx8rz16g93y9grl3hfqbh1jn21ama5jx";
  };

  buildInputs = [ gmp ];

  preBuild =
    ''
      sed -e s@/usr/@$out/@g -i Makefile
      cp ssss.manpage.xml ssss.1
      cp ssss.manpage.xml ssss.1.html
      mkdir -p $out/bin $out/share/man/man1
      echo -e 'install:\n\tcp ssss-combine ssss-split '"$out"'/bin' >>Makefile
    '';

  meta = {
    description = "Shamir Secret Sharing Scheme";
    homepage = http://point-at-infinity.org/ssss/;
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.gpl2;
  };
}

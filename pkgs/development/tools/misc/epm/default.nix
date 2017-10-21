{stdenv, fetchurl, rpm}:

stdenv.mkDerivation rec {
  name = "epm-${version}";
  version = "4.2";

  src = fetchurl {
    url = "http://www.msweet.org/files/project2/epm-4.2-source.tar.bz2";
    sha256 = "13imglm1fgd7p5y9lc0xsl6x4cdjsk5lnan5sn8f7m4jwbx8kik6";
  };

  buildInputs = [ rpm ];

  meta = with stdenv.lib; {
    description = "The ESP Package Manager generates distribution archives for a variety of platforms";
    homepage = http://www.msweet.org/projects.php?Z2;
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.unix;
  };
}

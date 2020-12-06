{ stdenv, fetchurl, perl, gettext }:

stdenv.mkDerivation rec {
  pname = "texi2html";
  version = "5.0";

  src = fetchurl {
    url = "mirror://savannah/texi2html/${pname}-${version}.tar.bz2";
    sha256 = "1yprv64vrlcbksqv25asplnjg07mbq38lfclp1m5lj8cw878pag8";
  };

  nativeBuildInputs = [ gettext ];
  buildInputs = [ perl ];

  preBuild = ''
    substituteInPlace separated_to_hash.pl \
      --replace "/usr/bin/perl" "${perl}/bin/perl"
  '';

  meta = with stdenv.lib; {
    description = "Perl script which converts Texinfo source files to HTML output";
    homepage = "https://www.nongnu.org/texi2html/";
    license = licenses.gpl2;
    maintainers = [ maintainers.marcweber ];
    platforms = platforms.unix;
  };
}

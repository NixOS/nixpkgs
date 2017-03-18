{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "catdoc-${version}";
  version = "0.95";

  src = fetchurl {
    url = "http://ftp.wagner.pp.ru/pub/catdoc/${name}.tar.gz";
    sha256 = "514a84180352b6bf367c1d2499819dfa82b60d8c45777432fa643a5ed7d80796";
  };

  configureFlags = "--disable-wordview";

  meta = with stdenv.lib; {
    description = "MS-Word/Excel/PowerPoint to text converter";
    platforms = platforms.all;
    license = licenses.gpl2;
    maintainers = with maintainers; [ urkud ndowens ];
  };
}

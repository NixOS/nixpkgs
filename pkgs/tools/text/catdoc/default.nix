{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "catdoc-0.94.2";
  src = fetchurl {
    url = "http://ftp.wagner.pp.ru/pub/catdoc/${name}.tar.gz";
    sha256 = "0qnk8fw3wc40qa34yqz51g0knif2jd78a4717nvd3rb46q88pj83";
  };

  configureFlags = "--disable-wordview";

  meta = with stdenv.lib; {
    description = "MS-Word/Excel/PowerPoint to text converter";
    platforms = platforms.all;
    license = "GPL2";
    maintainers = [ maintainers.urkud ];
  };
}

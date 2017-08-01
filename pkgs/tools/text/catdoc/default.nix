{ stdenv, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  name = "catdoc-${version}";
  version = "0.95";

  src = fetchurl {
    url = "http://ftp.wagner.pp.ru/pub/catdoc/${name}.tar.gz";
    sha256 = "514a84180352b6bf367c1d2499819dfa82b60d8c45777432fa643a5ed7d80796";
  };

  patches = [
    (fetchpatch {
      url = "https://anonscm.debian.org/git/collab-maint/catdoc.git/diff/debian/patches/05-CVE-2017-11110.patch?id=21dd5b29b11be04149587657dd90253f52dfef0b";
      sha256 = "0mdqa9w1p6cmli6976v4wi0sw9r4p5prkj7lzfd1877wk11c9c73";
    })
  ];

  configureFlags = "--disable-wordview";

  meta = with stdenv.lib; {
    description = "MS-Word/Excel/PowerPoint to text converter";
    platforms = platforms.all;
    license = licenses.gpl2;
    maintainers = with maintainers; [ ndowens ];
  };
}

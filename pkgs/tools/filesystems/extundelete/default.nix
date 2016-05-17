{ stdenv, fetchurl, e2fsprogs }:

stdenv.mkDerivation rec {
  version = "0.2.4";
  name = "extundelete-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/extundelete/extundelete-0.2.4.tar.bz2";
    sha256 = "1x0r7ylxlp9lbj3d7sqf6j2a222dwy2nfpff05jd6mkh4ihxvyd1";
  };

  buildInputs = [ e2fsprogs ];

  meta = with stdenv.lib; {
    description = "utility that can recover deleted files from an ext3 or ext4 partition";
    homepage = http://extundelete.sourceforge.net/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.domenkozar ];
  };
}

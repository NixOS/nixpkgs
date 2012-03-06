{ stdenv, fetchurl, libusb, qt4 }:

stdenv.mkDerivation  rec {
  name = "rockbox-utility-${version}";
  version = "1.2.8";

  src = fetchurl {
    url = "http://download.rockbox.org/rbutil/source/rbutil_${version}-src.tar.bz2";
    sha256 = "1gjwlyrwvzfdhqdwvq1chdnjkcn9lk21ixp92h5y74826j3ahdgs";
  };

  buildInputs = [ libusb qt4 ];

  preBuild = ''
    cd rbutil/rbutilqt
    qmake
  '';

  installPhase = ''
    mkdir -p $out/bin 
    cp RockboxUtility $out/bin
  '';

  meta = with stdenv.lib; {
    description = "open source firmware for mp3 players";
    homepage = http://www.rockbox.org;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}

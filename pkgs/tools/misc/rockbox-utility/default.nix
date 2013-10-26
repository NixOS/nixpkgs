{ stdenv, fetchurl, libusb1, qt4 }:

stdenv.mkDerivation  rec {
  name = "rockbox-utility-${version}";
  version = "1.3.1";

  src = fetchurl {
    url = "http://download.rockbox.org/rbutil/source/RockboxUtility-v${version}-src.tar.bz2";
    sha256 = "6c04b5c7eaad1762577908dedb9e40f5b0cee675150ae5ba844ea2c9bea294ca";
  };

  buildInputs = [ libusb1 qt4 ];

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

{ stdenv, fetchurl, libusb1, qt4, qmake4Hook }:

stdenv.mkDerivation  rec {
  name = "rockbox-utility-${version}";
  version = "1.4.0";

  src = fetchurl {
    url = "http://download.rockbox.org/rbutil/source/RockboxUtility-v${version}-src.tar.bz2";
    sha256 = "0k3ycga3b0jnj13whwiip2l0gx32l50pnbh7kfima87nq65aaa5w";
  };

  buildInputs = [ libusb1 qt4 ];
  nativeBuildInputs = [ qmake4Hook ];

  preConfigure = ''
    cd rbutil/rbutilqt
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
    maintainers = with maintainers; [ goibhniu jgeerds ];
  };
}

{ stdenv, fetchurl, libusb1, qt5 }:

stdenv.mkDerivation  rec {
  name = "rockbox-utility-${version}";
  version = "1.4.0";

  src = fetchurl {
    url = "http://download.rockbox.org/rbutil/source/RockboxUtility-v${version}-src.tar.bz2";
    sha256 = "0k3ycga3b0jnj13whwiip2l0gx32l50pnbh7kfima87nq65aaa5w";
  };

  buildInputs = [ libusb1 ] ++ (with qt5; [ qtbase qttools ]);
  nativeBuildInputs = [ qt5.qmakeHook ];

  preConfigure = ''
    cd rbutil/rbutilqt
  '';

  installPhase = ''
    install -Dm755 RockboxUtility $out/bin/RockboxUtility
  '';

  meta = with stdenv.lib; {
    description = "Open source firmware for mp3 players";
    homepage = http://www.rockbox.org;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ goibhniu jgeerds ];
  };
}

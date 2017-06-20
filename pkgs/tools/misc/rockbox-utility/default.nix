{ stdenv, fetchurl, pkgconfig, libusb1
, qtbase, qttools, makeWrapper, qmake
, withEspeak ? false, espeak ? null }:

stdenv.mkDerivation  rec {
  name = "rockbox-utility-${version}";
  version = "1.4.0";

  src = fetchurl {
    url = "http://download.rockbox.org/rbutil/source/RockboxUtility-v${version}-src.tar.bz2";
    sha256 = "0k3ycga3b0jnj13whwiip2l0gx32l50pnbh7kfima87nq65aaa5w";
  };

  buildInputs = [ libusb1 qtbase qttools ]
    ++ stdenv.lib.optional withEspeak espeak;
  nativeBuildInputs = [ makeWrapper pkgconfig qmake ];

  preConfigure = ''
    cd rbutil/rbutilqt
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 RockboxUtility $out/bin/rockboxutility
    ln -s $out/bin/rockboxutility $out/bin/RockboxUtility
    wrapProgram $out/bin/rockboxutility \
    ${stdenv.lib.optionalString withEspeak ''
      --prefix PATH : ${espeak}/bin
    ''}

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Open source firmware for mp3 players";
    homepage = http://www.rockbox.org;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ goibhniu jgeerds ];
  };
}

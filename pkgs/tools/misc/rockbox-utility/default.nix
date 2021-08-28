{ lib, stdenv, fetchurl, pkg-config, cryptopp
, libusb1, qtbase, qttools, makeWrapper
, qmake, withEspeak ? false, espeak ? null
, qt5 }:

let inherit (lib) getDev; in

stdenv.mkDerivation  rec {
  pname = "rockbox-utility";
  version = "1.4.1";

  src = fetchurl {
    url = "https://download.rockbox.org/rbutil/source/RockboxUtility-v${version}-src.tar.bz2";
    sha256 = "0zm9f01a810y7aq0nravbsl0vs9vargwvxnfl4iz9qsqygwlj69y";
  };

  buildInputs = [ cryptopp libusb1 qtbase qttools ]
    ++ lib.optional withEspeak espeak;
  nativeBuildInputs = [ makeWrapper pkg-config qmake qt5.wrapQtAppsHook ];

  postPatch = ''
    sed -i rbutil/rbutilqt/rbutilqt.pro \
        -e '/^lrelease.commands =/ s|$$\[QT_INSTALL_BINS\]/lrelease -silent|${getDev qttools}/bin/lrelease|'
  '';

  preConfigure = ''
    cd rbutil/rbutilqt
    lrelease rbutilqt.pro
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 RockboxUtility $out/bin/rockboxutility
    ln -s $out/bin/rockboxutility $out/bin/RockboxUtility
    wrapProgram $out/bin/rockboxutility \
    ${lib.optionalString withEspeak ''
      --prefix PATH : ${espeak}/bin
    ''}

    runHook postInstall
  '';

  # `make build/rcc/qrc_rbutilqt-lang.cpp` fails with
  #      RCC: Error in 'rbutilqt-lang.qrc': Cannot find file 'lang/rbutil_cs.qm'
  # Do not add `lrelease rbutilqt.pro` into preConfigure, otherwise `make lrelease`
  # may clobber the files read by the parallel `make build/rcc/qrc_rbutilqt-lang.cpp`.
  enableParallelBuilding = false;

  meta = with lib; {
    description = "Open source firmware for mp3 players";
    homepage = "https://www.rockbox.org";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ goibhniu ];
  };
}

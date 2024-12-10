{
  lib,
  stdenv,
  fetchurl,
  cryptopp,
  libusb1,
  makeWrapper,
  pkg-config,
  qt5,
  withEspeak ? false,
  espeak ? null,
}:

stdenv.mkDerivation rec {
  pname = "rockbox-utility";
  version = "1.4.1";

  src = fetchurl {
    url = "https://download.rockbox.org/rbutil/source/RockboxUtility-v${version}-src.tar.bz2";
    hash = "sha256-PhlJ+fNY4/Qjoc72zV9WO+kNqF5bZQuwOh4EpAJwqX4=";
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    qt5.qmake
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    cryptopp
    libusb1
    qt5.qtbase
    qt5.qttools
  ] ++ lib.optional withEspeak espeak;

  postPatch = ''
    sed -i rbutil/rbutilqt/rbutilqt.pro \
        -e '/^lrelease.commands =/ s|$$\[QT_INSTALL_BINS\]/lrelease -silent|${lib.getDev qt5.qttools}/bin/lrelease|'
  '';

  preConfigure = ''
    cd rbutil/rbutilqt
    lrelease rbutilqt.pro
  '';

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: libmkimxboot.a(elf.c.o):utils/imxtools/sbtools/misc.h:43: multiple definition of `g_nr_keys';
  #     libmkimxboot.a(mkimxboot.c.o):utils/imxtools/sbtools/misc.h:43: first defined here
  # TODO: try to remove with 1.5.1 update.
  env.NIX_CFLAGS_COMPILE = "-fcommon";

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
    homepage = "https://www.rockbox.org";
    description = "Open source firmware for digital music players";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      AndersonTorres
      goibhniu
    ];
    platforms = platforms.linux;
  };
}

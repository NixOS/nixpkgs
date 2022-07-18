{ stdenv
, lib
, fetchFromGitHub
, unstableGitUpdater
, dos2unix
, pkg-config
, zlib
, alsa-lib
, libjack2
}:

stdenv.mkDerivation rec {
  pname = "fmtoy";
  version = "unstable-2021-12-24";

  src = fetchFromGitHub {
    owner = "vampirefrog";
    repo = "fmtoy";
    rev = "0de6703b3373eb5bf19fd3deaae889286f330c21";
    sha256 = "0sr6klkmjd2hd2kyb9y0x986d6lsy8bziizfc6cmhkqcq92fh45c";
  };

  postPatch = ''
    dos2unix Makefile
    # Don't hardcode compilers
    sed -i -e '/CC=/d' -e '/CXX=/d' Makefile
  '' + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Remove Linux-only program & its dependencies
    sed -i -e '/PROGS/ s/fmtoy_jack//' Makefile
    substituteInPlace Makefile \
      --replace '$(shell pkg-config alsa jack --cflags)' ""
  '';

  nativeBuildInputs = [
    dos2unix
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
  ];

  buildInputs = [
    zlib
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    libjack2
  ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    for prog in $(grep 'PROGS=' Makefile | cut -d= -f2-); do
      install -Dm755 $prog $out/bin/$prog
    done

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/vampirefrog/fmtoy.git";
  };

  meta = with lib; {
    homepage = "https://github.com/vampirefrog/fmtoy";
    description = "Tools for FM voices for Yamaha YM chips (OPL, OPM and OPN series)";
    # Unknown license situation
    # https://github.com/vampirefrog/fmtoy/issues/1
    license = licenses.unfree;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.all;
  };
}

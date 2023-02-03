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
  version = "unstable-2022-12-23";

  src = fetchFromGitHub {
    owner = "vampirefrog";
    repo = "fmtoy";
    rev = "78b61b5e9bc0c6874962dc4040456581c9999b36";
    sha256 = "r5zbr6TCxzDiQvDsLQu/QwNfem1K4Ahaji0yIz/2yl0=";
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
    # Unclear if gpl3Only or gpl3Plus
    # https://github.com/vampirefrog/fmtoy/issues/1
    license = licenses.gpl3;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.all;
  };
}

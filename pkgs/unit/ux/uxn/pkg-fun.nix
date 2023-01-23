{ lib
, stdenv
, fetchFromSourcehut
, SDL2
}:

stdenv.mkDerivation {
  pname = "uxn";
  version = "unstable-2022-10-22";

  src = fetchFromSourcehut {
    owner = "~rabbits";
    repo = "uxn";
    rev = "1b2049e238df96f32335edf1c6db35bd09f8b42d";
    hash = "sha256-lwms+qUelfpTC+i2m5b3dW7ww9298YMPFdPVsFrwcDQ=";
  };

  buildInputs = [
    SDL2
  ];

  dontConfigure = true;

  postPatch = ''
     sed -i -e 's|UXNEMU_LDFLAGS="$(brew.*$|UXNEMU_LDFLAGS="$(sdl2-config --cflags --libs)"|' build.sh
  '';

  buildPhase = ''
    runHook preBuild

    ./build.sh --no-run

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -d $out/bin/ $out/share/uxn/

    cp bin/uxnasm bin/uxncli bin/uxnemu $out/bin/
    cp -r projects $out/share/uxn/

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://wiki.xxiivv.com/site/uxn.html";
    description = "An assembler and emulator for the Uxn stack machine";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ AndersonTorres kototama ];
    platforms = with platforms; unix;
  };
}

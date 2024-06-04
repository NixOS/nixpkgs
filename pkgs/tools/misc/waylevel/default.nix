{ lib
, fetchFromSourcehut
, rustPlatform
, wayland
}:
rustPlatform.buildRustPackage rec {
  pname = "waylevel";
  version = "1.0.0";

  src = fetchFromSourcehut {
    owner = "~shinyzenith";
    repo = pname;
    rev = version;
    hash = "sha256-T2gqiRcKrKsvwGNnWrxR1Ga/VX4AyllYn1H25aIKt5s=";
  };

  cargoHash = "sha256-gw5m1/btJ5zZP04C7BCnHqEOUBoeu0whK8W7xA+xSQo=";

  postFixup = ''
    patchelf --set-rpath ${lib.makeLibraryPath [wayland]} $out/bin/waylevel
  '';

  meta = with lib; {
    description = "A tool to print wayland toplevels and other compositor info";
    homepage = "https://git.sr.ht/~shinyzenith/waylevel";
    license = licenses.bsd2;
    maintainers = with maintainers; [ dit7ya ];
    platforms = platforms.linux;
    mainProgram = "waylevel";
  };
}

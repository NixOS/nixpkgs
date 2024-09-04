{ lib, fetchCrate, rustPlatform, pkg-config, libXrandr, libX11, python3 }:

rustPlatform.buildRustPackage rec {
  pname = "hacksaw";
  version = "1.0.4";

  nativeBuildInputs = [ pkg-config python3 ];

  buildInputs = [ libXrandr libX11 ];

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-HRYTiccXU8DboAwZAr2gfzXUs8igSiFDpOEGtHpI0dA=";
  };

  cargoHash = "sha256-CDDJmWnAcXJ4wPfSPvu2DfthaFwZGZk1XXMNTA1g0+c=";

  meta = with lib; {
    description = "Lightweight selection tool for usage in screenshot scripts etc";
    homepage = "https://github.com/neXromancers/hacksaw";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ TethysSvensson ];
    platforms = platforms.linux;
    mainProgram = "hacksaw";
  };
}

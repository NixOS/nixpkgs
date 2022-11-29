{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "wayshot";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "waycrate";
    repo = pname;
    rev = version;
    hash = "sha256-/uZ98ICdPTilUD3vBEbJ4AxGWY1xIbkK6O+bkhqIUKA=";
  };

  cargoHash = "sha256-j/gSrXY5n/zW3IogHewyrupTKtEm5EtOzfOzglyTP9A=";

  meta = with lib; {
    description = "A native, blazing-fast screenshot tool for wlroots based compositors such as sway and river";
    homepage = "https://github.com/waycrate/wayshot";
    license = licenses.bsd2;
    maintainers = [ maintainers.dit7ya ];
    platforms = platforms.linux;
  };
}

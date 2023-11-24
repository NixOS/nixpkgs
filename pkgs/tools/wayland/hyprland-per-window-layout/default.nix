{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "hyprland-per-window-layout";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "coffebar";
    repo = pname;
    rev = version;
    hash = "sha256-zH0N7m8cvc47MM7+DAIgg/S6onpIwoB9CfcAmRqhtGA=";
  };

  cargoHash = "sha256-rYTptEB+2Adlb1y7oXO+noqNylwiHBAb49ufZdPL9Qc=";

  meta = with lib; {
    description = "Per window keyboard layout (language) for Hyprland wayland compositor";
    homepage = "https://github.com/coffebar/hyprland-per-window-layout";
    license = licenses.mit;
    maintainers = [ maintainers.azazak123 ];
    platforms = platforms.linux;
  };
}

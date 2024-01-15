{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "hyprland-per-window-layout";
  version = "2.5";

  src = fetchFromGitHub {
    owner = "coffebar";
    repo = pname;
    rev = version;
    hash = "sha256-muEM0jRNZ8osuZ6YSyNPFD/2IuXoNbR28It9cKeJwZ4=";
  };

  cargoHash = "sha256-g7VCjxrf6qP6KcTNhHzFEFwP4EiIRTnjK6n93FGee54=";

  meta = with lib; {
    description = "Per window keyboard layout (language) for Hyprland wayland compositor";
    homepage = "https://github.com/coffebar/hyprland-per-window-layout";
    license = licenses.mit;
    maintainers = [ maintainers.azazak123 ];
    platforms = platforms.linux;
    mainProgram = "hyprland-per-window-layout";
  };
}

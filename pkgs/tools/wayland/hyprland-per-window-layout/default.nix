{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "hyprland-per-window-layout";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "coffebar";
    repo = pname;
    rev = version;
    hash = "sha256-a1x22+f7VXkPC36/muauac0+mz2Bcr01TFWf+sGHH/g=";
  };

  cargoHash = "sha256-R79ztYRLokGc4wQnoJeKsY/4EuCGuhdqBhBQVstY2gU=";

  meta = with lib; {
    description = "Per window keyboard layout (language) for Hyprland wayland compositor";
    homepage = "https://github.com/coffebar/hyprland-per-window-layout";
    license = licenses.mit;
    maintainers = [ maintainers.azazak123 ];
    platforms = platforms.linux;
    mainProgram = "hyprland-per-window-layout";
  };
}

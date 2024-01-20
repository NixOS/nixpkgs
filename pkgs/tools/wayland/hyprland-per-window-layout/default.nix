{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "hyprland-per-window-layout";
  version = "2.6";

  src = fetchFromGitHub {
    owner = "coffebar";
    repo = pname;
    rev = version;
    hash = "sha256-g6cFZXEWKB9IxP/ARe788tXFpDofJNDWMwUU15yKYhA=";
  };

  cargoHash = "sha256-kVu81NnwcKksHeS5ZM/SgTuh2olMgdBBxY3cJxwuW0Q=";

  meta = with lib; {
    description = "Per window keyboard layout (language) for Hyprland wayland compositor";
    homepage = "https://github.com/coffebar/hyprland-per-window-layout";
    license = licenses.mit;
    maintainers = [ maintainers.azazak123 ];
    platforms = platforms.linux;
    mainProgram = "hyprland-per-window-layout";
  };
}

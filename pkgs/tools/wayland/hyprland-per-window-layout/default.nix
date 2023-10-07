{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "hyprland-per-window-layout";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "coffebar";
    repo = pname;
    rev = version;
    hash = "sha256-eqhGX9rjvOHh6RuWj5dqWPKlFdTnZpAcDUuJbT3Z/E8=";
  };

  cargoHash = "sha256-AUkBTHShtY3ZJ8pxCuW9baVuxb2QxzXxJQMgbuVTlPY=";

  meta = with lib; {
    description = "Per window keyboard layout (language) for Hyprland wayland compositor";
    homepage = "https://github.com/coffebar/hyprland-per-window-layout";
    license = licenses.mit;
    maintainers = [ maintainers.azazak123 ];
    platforms = platforms.linux;
  };
}

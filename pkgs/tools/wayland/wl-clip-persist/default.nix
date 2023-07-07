{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, wayland
}:

rustPlatform.buildRustPackage {
  pname = "wl-clip-persist";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "Linus789";
    repo = "wl-clip-persist";
    # upstream doesn't tag releases
    rev = "6ba11a2aa295d780f0b2e8f005cf176601d153b0";
    hash = "sha256-wg4xEXLAZpWflFejP7ob4cnmRvo9d/0dL9hceG+RUr0=";
  };

  cargoHash = "sha256-vNxNvJ5tA323EVArJ6glNslkq/Q6u7NsIpTYO1Q3GEw=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    wayland
  ];

  meta = with lib; {
    inherit (wayland.meta) platforms;
    homepage = "https://github.com/Linus789/wl-clip-persist";
    description = "Keep Wayland clipboard even after programs close";
    license = licenses.mit;
    maintainers = with maintainers; [ thiagokokada ];
    broken = stdenv.isDarwin;
  };
}

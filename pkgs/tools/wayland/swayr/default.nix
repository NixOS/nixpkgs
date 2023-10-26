{ lib, fetchFromSourcehut, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "swayr";
  version = "0.27.1";

  src = fetchFromSourcehut {
    owner = "~tsdh";
    repo = "swayr";
    rev = "swayr-${version}";
    sha256 = "sha256-0qWrVf7Ou7psczg3vlFMh/QO95yPBUZ/fKQ7w0sE/4I=";
  };

  cargoHash = "sha256-r8QcLYBKOfUdzwmohUfg4ZrLqQudIfHB/DETO9byrB0=";

  patches = [
    ./icon-paths.patch
  ];

  # don't build swayrbar
  buildAndTestSubdir = pname;

  preCheck = ''
    export HOME=$TMPDIR
  '';

  meta = {
    description = "A window switcher (and more) for sway";
    homepage = "https://git.sr.ht/~tsdh/swayr";
    license = lib.licenses.gpl3Plus;
    mainProgram = "swayr";
    maintainers = with lib.maintainers; [ artturin ];
    platforms = lib.platforms.linux;
  };
}

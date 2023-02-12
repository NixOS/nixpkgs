{ lib
, stdenv
, fetchFromGitHub
, SDL2
, SDL2_ttf
, installShellFiles
, ncurses
, pkg-config
, ui ? "terminal"
}:

assert lib.elem ui [ "terminal" "curses" "sdl" ];
stdenv.mkDerivation (self: {
  pname = "2048-cli";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "tiehuis";
    repo = "2048-cli";
    rev = "v${self.version}";
    hash = "sha256-pLOrUilIrA+wo3iePhSXSK1UhbcjKyAx4SpKcC0I2yY=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace "-lcurses" "-lncurses"
  '';

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs =
    (lib.optional (ui == "curses") ncurses)
    ++ (lib.optionals (ui == "sdl") [ SDL2 SDL2_ttf ]);

  dontConfigure = true;

  NIX_CFLAGS_COMPILE = lib.optionalString (ui == "sdl") "-I${SDL2_ttf}/include/SDL2";

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    ui
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin 2048
    installManPage man/2048.1

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/tiehuis/2048-cli";
    description = "The game 2048 for your Linux terminal";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.AndersonTorres ];
    platforms = lib.platforms.unix;
    broken = (ui == "sdl"); # segmentation fault
  };
})

{ lib
, stdenv
, fetchFromGitHub
, gettext
, installShellFiles
, ncurses
, ui ? "terminal"
}:

assert lib.elem ui [ "terminal" "curses" ];
stdenv.mkDerivation (finalAttrs: {
  pname = "2048-cli";
  version = "unstable-2019-12-10";

  src = fetchFromGitHub {
    owner = "tiehuis";
    repo = "2048-cli";
    rev = "67439255df7d4f70209ca628d65128cd41d33e8d";
    hash = "sha256-U7g2wCZgR7Lp/69ktQIZZ1cScll2baCequemTl3Mc3I=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace "-lcurses" "-lncurses"
  '';

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = [
    gettext
  ]
  ++ (lib.optional (ui == "curses") ncurses);

  dontConfigure = true;

  env.NIX_CFLAGS_COMPILE = "-I${lib.getDev gettext}/share/gettext/";

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    ui
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin 2048
    installManPage man/2048.6

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/tiehuis/2048-cli";
    description = "The game 2048 for your Linux terminal";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.AndersonTorres ];
    platforms = lib.platforms.unix;
    mainProgram = "2048";
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
  SDL,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "curseofwar";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "a-nikolaev";
    repo = "curseofwar";
    rev = "v${finalAttrs.version}";
    sha256 = "1wd71wdnj9izg5d95m81yx3684g4zdi7fsy0j5wwnbd9j34ilz1i";
  };

  buildInputs = [
    ncurses
    SDL
  ];

  makeFlags = (lib.optionals (SDL != null) [ "SDL=yes" ]) ++ [
    "PREFIX=$(out)"
    # force platform's cc on darwin, otherwise gcc is used
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  meta = with lib; {
    description = "Fast-paced action strategy game";
    homepage = "https://a-nikolaev.github.io/curseofwar/";
    license = licenses.gpl3;
    mainProgram = if SDL != null then "curseofwar-sdl" else "curseofwar";
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
})

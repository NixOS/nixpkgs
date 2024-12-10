{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
  Foundation,
  glew,
  SDL2,
  writeShellScript,
}:

let
  datadir = "\"\${XDG_DATA_HOME:-$HOME/.local/share}\"/wipeout-rewrite";
  datadirCheck = writeShellScript "wipeout-rewrite-check-datadir.sh" ''
    datadir=${datadir}

    if [ ! -d "$datadir" ]; then
      echo "[Wrapper] Creating data directory $datadir"
      mkdir -p "$datadir"
    fi

    echo "[Wrapper] Remember to put your game assets into $datadir/wipeout if you haven't done so yet!"
    echo "[Wrapper] Check https://github.com/phoboslab/wipeout-rewrite#running for the required format."
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "wipeout-rewrite";
  version = "unstable-2023-08-13";

  src = fetchFromGitHub {
    owner = "phoboslab";
    repo = "wipeout-rewrite";
    rev = "7a9f757a79d5c6806252cc1268bda5cdef463e23";
    hash = "sha256-21IG9mZPGgRhVkT087G+Bz/zLkknkHKGmWjSpcLw8vE=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs =
    [
      glew
      SDL2
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      Foundation
    ];

  installPhase = ''
    runHook preInstall

    install -Dm755 wipegame $out/bin/wipegame

    # I can't get --chdir to not expand the bash variables in datadir at build time (so they point to /homeless-shelter)
    # or put them inside single quotes (breaking the expansion at runtime)
    wrapProgram $out/bin/wipegame \
      --run '${datadirCheck}' \
      --run 'cd ${datadir}'

    runHook postInstall
  '';

  meta = with lib; {
    mainProgram = "wipegame";
    description = "A re-implementation of the 1995 PSX game wipEout";
    homepage = "https://github.com/phoboslab/wipeout-rewrite";
    license = licenses.unfree;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.all;
  };
})

{ pkgs, lib, stdenv, fetchFromGitHub, writeScript, makeWrapper, ncurses, libX11 }:

let
  setup = writeScript "setup" ''
    mkdir -p "$ANGBAND_PATH"
    # copy all the data files into place
    cp -ar $1/* "$ANGBAND_PATH"
    # the copied files need to be writable
    chmod +w -R "$ANGBAND_PATH"
  '';
in stdenv.mkDerivation rec {
  pname = "sil-q";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "sil-quirk";
    repo = "sil-q";
    rev = "v${version}";
    sha256 = "sha256-v/sWhPWF9cCKD8N0RHpwzChMM1t9G2yrMDmi1cZxdOs=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ ncurses libX11 ];

  # Makefile(s) and config are not top-level
  sourceRoot = "${src.name}/src";

  postPatch = ''
    # allow usage of ANGBAND_PATH
    substituteInPlace config.h --replace "#define FIXED_PATHS" ""

    # change Makefile.std for ncurses according to its own comment
    substituteInPlace Makefile.std --replace "-lcurses" "-lncurses"
  '';

  makefile = "Makefile.std";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp sil $out/bin/sil-q
    wrapProgram $out/bin/sil-q \
      --run "export ANGBAND_PATH=\$HOME/.sil-q" \
      --run "${setup} ${src}/lib"

    runHook postInstall
  '';

  passthru.tests = {
    saveDirCreation = pkgs.runCommand "save-dir-creation" {} ''
      HOME=$(pwd) ${lib.getExe pkgs.sil-q} --help
      test -d .sil-q && touch $out
    '';
  };

  meta = {
    description = "Roguelike game set in the First Age of Middle-earth";
    mainProgram = "sil-q";
    longDescription = ''
      A game of adventure set in the First Age of Middle-earth, when the world still
      rang with Elven song and gleamed with Dwarven mail.

      Walk the dark halls of Angband.  Slay creatures black and fell.  Wrest a shining
      Silmaril from Morgoth’s iron crown.

      A fork of Sil that's still actively developed.
    '';
    homepage = "https://github.com/sil-quirk/sil-q";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.kenran ];
    platforms = lib.platforms.linux;
  };
}

{
  lib,
  stdenv,
  fetchFromGitLab,
  makeWrapper,
  ocamlPackages,
  remind,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wyrd";
  version = "1.7.4";

  src = fetchFromGitLab {
    owner = "wyrd-calendar";
    repo = "wyrd";
    tag = finalAttrs.version;
    hash = "sha256-9HCwc4yrBi0D+fv7vOPstxN1tqqNyGRgpkce1uLVxTg=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    makeWrapper
    ocamlPackages.findlib
    ocamlPackages.ocaml
    ocamlPackages.odoc
  ];

  buildInputs = [
    ocamlPackages.camlp-streams
    ocamlPackages.curses
    ocamlPackages.yojson
    remind
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  postInstall = ''
    wrapProgram "$out/bin/wyrd" \
      --prefix PATH : "${lib.makeBinPath [ remind ]}"
  '';

  meta = {
    description = "Text-based front-end to Remind";
    longDescription = ''
      Wyrd is a text-based front-end to Remind, a sophisticated
      calendar and alarm program. Remind's power lies in its
      programmability, and Wyrd does not hide this capability behind
      flashy GUI dialogs. Rather, Wyrd is designed to make you more
      efficient at editing your reminder files directly.
    '';
    homepage = "https://gitlab.com/wyrd-calendar/wyrd";
    downloadPage = "https://gitlab.com/wyrd-calendar/wyrd";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.prikhi ];
    platforms = lib.platforms.unix;
    mainProgram = "wyrd";
  };
})

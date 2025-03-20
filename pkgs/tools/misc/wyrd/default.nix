{
  lib,
  stdenv,
  fetchFromGitLab,
  makeWrapper,
  ocamlPackages,
  remind,
}:

stdenv.mkDerivation rec {
  pname = "wyrd";
  version = "1.7.1";

  src = fetchFromGitLab {
    owner = "wyrd-calendar";
    repo = "wyrd";
    tag = version;
    hash = "sha256-RwGzXJLoCWRGgHf1rayBgkZuRwA1TcYNfN/h1rhJC+8=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    makeWrapper
    ocamlPackages.findlib
    ocamlPackages.ocaml
    ocamlPackages.odoc
  ];

  buildInputs = [
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

  meta = with lib; {
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
    license = licenses.gpl2Only;
    maintainers = [ maintainers.prikhi ];
    platforms = platforms.unix;
    mainProgram = "wyrd";
  };
}

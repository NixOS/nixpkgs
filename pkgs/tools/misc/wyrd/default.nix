{
  lib,
  stdenv,
  fetchurl,
  ocamlPackages,
  ncurses,
  remind,
}:

stdenv.mkDerivation rec {
  version = "1.4.6";
  pname = "wyrd";

  src = fetchurl {
    url = "http://pessimization.com/software/wyrd/wyrd-${version}.tar.gz";
    sha256 = "0zlrg602q781q8dij62lwdprpfliyy9j1rqfqcz8p2wgndpivddj";
  };

  preConfigure = ''
    substituteInPlace curses/curses.ml --replace 'pp gcc' "pp $CC"
  '';

  strictDeps = true;
  nativeBuildInputs = [
    ocamlPackages.ocaml
    ocamlPackages.camlp4
  ];
  buildInputs = [
    ncurses
    remind
  ];

  preferLocalBuild = true;

  meta = with lib; {
    description = "Text-based front-end to Remind";
    longDescription = ''
      Wyrd is a text-based front-end to Remind, a sophisticated
      calendar and alarm program. Remind's power lies in its
      programmability, and Wyrd does not hide this capability behind
      flashy GUI dialogs. Rather, Wyrd is designed to make you more
      efficient at editing your reminder files directly.
    '';
    homepage = "http://pessimization.com/software/wyrd/";
    downloadPage = "http://pessimization.com/software/wyrd/";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.prikhi ];
    platforms = platforms.unix;
    mainProgram = "wyrd";
  };
}

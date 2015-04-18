{ stdenv, fetchurl, ocaml, ncurses, remind }:

stdenv.mkDerivation rec {
  version = "1.4.6";
  name = "wyrd-${version}";

  src = fetchurl {
    url = "http://pessimization.com/software/wyrd/wyrd-${version}.tar.gz";
    sha256 = "0zlrg602q781q8dij62lwdprpfliyy9j1rqfqcz8p2wgndpivddj";
  };

  buildInputs = [ ocaml ncurses remind ];

  preferLocalBuild = true;

  meta = with stdenv.lib; {
    description = "A text-based front-end to Remind";
    longDescription = ''
      Wyrd is a text-based front-end to Remind, a sophisticated
      calendar and alarm program. Remind's power lies in its
      programmability, and Wyrd does not hide this capability behind
      flashy GUI dialogs. Rather, Wyrd is designed to make you more
      efficient at editing your reminder files directly.
    '';
    homepage = http://pessimization.com/software/wyrd/;
    downloadPage = http://pessimization.com/software/wyrd/;
    license = licenses.gpl2;
    maintainers = [ maintainers.prikhi ];
    platforms = platforms.linux;
  };
}

{ stdenv, fetchFromGitHub, autoreconfHook, gtk_engines }:

stdenv.mkDerivation rec {
  version = "2016-05-25";
  name = "paper-gtk-theme-${version}";

  src = fetchFromGitHub {
    owner = "snwh";
    repo = "paper-gtk-theme";
    rev = "dea5f97b12e4f41dddbd01a1529760761aa3784e";
    sha256 = "0fln555827hrn554qcil3rwl9x4x3vdfbh2vplkc8r46a3bn8yng";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ gtk_engines ];

  postPatch = ''
    substituteInPlace Makefile.am --replace '$(DESTDIR)'/usr $out
  '';

  preferLocalBuild = true;

  meta = with stdenv.lib; {
    description = "A modern desktop theme suite featuring a mostly flat with a minimal use of shadows for depth";
    homepage = "http://snwh.org/paper";
    license = licenses.gpl3;
    maintainers = [ maintainers.simonvandel maintainers.romildo ];
    platforms = platforms.linux;
  };
}

{ stdenv, fetchFromGitHub, autoreconfHook, gtk_engines }:

stdenv.mkDerivation rec {
  version = "2016-05-18";
  name = "paper-gtk-theme-${version}";

  src = fetchFromGitHub {
    owner = "snwh";
    repo = "paper-gtk-theme";
    rev = "5113d58dc64de70fcc75ad2d6d05c8c8dae2de7f";
    sha256 = "1j9l50iyvadpqsq5v14zgml24jgraajr5kl9ji0ar62nlak2bi8s";
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

{ stdenv, fetchFromGitHub, autoreconfHook, gtk_engines }:

stdenv.mkDerivation rec {
  version = "2016-05-27";
  name = "paper-gtk-theme-${version}";

  src = fetchFromGitHub {
    owner = "snwh";
    repo = "paper-gtk-theme";
    rev = "06fb8b41743dd99410c08a9beabc323e6631d009";
    sha256 = "1gffjsgs43rvxs8ryd5c3yfrp3a69d5wvjmiixwwp1qn1fr46dni";
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

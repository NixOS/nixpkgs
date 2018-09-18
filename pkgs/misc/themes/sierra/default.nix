{ stdenv, fetchFromGitHub, libxml2, gdk_pixbuf, librsvg, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "sierra-gtk-theme-${version}";
  version = "2018-09-14";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "sierra-gtk-theme";
    rev = "4c07f9e4978ab2d87ce0f8d4a5d60da21784172c";
    sha256 = "0mp5v462wbjq157hfnqzd8sw374mc611kpk92is2c3qhvj5qb6qd";
  };

  nativeBuildInputs = [ libxml2 ];

  buildInputs = [ gdk_pixbuf librsvg ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    patchShebangs .
    mkdir -p $out/share/themes
    name= ./install.sh --dest $out/share/themes
  '';

  meta = with stdenv.lib; {
    description = "A Mac OSX like theme for GTK based desktop environments";
    homepage = https://github.com/vinceliuice/Sierra-gtk-theme;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}

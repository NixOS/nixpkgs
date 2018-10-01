{ stdenv, fetchFromGitHub, libxml2, gdk_pixbuf, librsvg, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "sierra-gtk-theme-${version}";
  version = "2018-10-01";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "sierra-gtk-theme";
    rev = version;
    sha256 = "10rjk2lyhlkhhfx6f6r0cykbkxa2jhri4wirc3h2wbzzsx7ch3ix";
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

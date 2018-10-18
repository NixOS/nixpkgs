{ stdenv, fetchFromGitHub, gdk_pixbuf, librsvg, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "matcha-${version}";
  version = "2018-10-12";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "matcha";
    rev = "c1c91db44d9e28cc71af019784a77175a60a7b9d";
    sha256 = "0sr805ghgh8sr9nncs693b9p756nmi1l4d8mfywj6z219jhy77qv";
  };

  buildInputs = [ gdk_pixbuf librsvg ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    patchShebangs .
    substituteInPlace Install --replace '$HOME/.themes' "$out/share/themes"
    ./Install
    install -D -t $out/share/gtksourceview-3.0/styles src/extra/gedit/matcha.xml
  '';

  meta = with stdenv.lib; {
    description = "A stylish Design theme for GTK based desktop environments";
    homepage = https://vinceliuice.github.io/theme-matcha;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}

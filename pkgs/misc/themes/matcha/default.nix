{ stdenv, fetchFromGitHub, gdk_pixbuf, librsvg, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "matcha-${version}";
  version = "2018-09-14";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "matcha";
    rev = "fe35259742b5ae007ab17d46d21acad5754477b9";
    sha256 = "1qwb8l1xfx9ca2y9gcsckxikijz1ij28dirvpqvhbbyn1m8i9hwd";
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

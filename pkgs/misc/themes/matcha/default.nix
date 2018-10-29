{ stdenv, fetchFromGitHub, gdk_pixbuf, librsvg, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "matcha-${version}";
  version = "2018-10-21";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "matcha";
    rev = version;
    sha256 = "112xfnwlq9ih72qbfrin78ly7bc4i94my3i6s7yhc46qg1lncl73";
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

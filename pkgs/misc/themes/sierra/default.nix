{ stdenv, fetchFromGitHub, libxml2, gdk_pixbuf, librsvg, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "sierra-gtk-theme-${version}";
  version = "2018-10-12";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "sierra-gtk-theme";
    rev = version;
    sha256 = "0l8mhdy7x8nh5aqsvkk0maqg1cnfds7824g439f6cmifdiyksbgg";
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

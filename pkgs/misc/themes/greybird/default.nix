{ stdenv, fetchFromGitHub, autoreconfHook, which, sassc, glib, libxml2, gdk_pixbuf, librsvg, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "greybird";
  version = "3.22.9";

  src = fetchFromGitHub {
    owner = "shimmerproject";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "0mixs47v0jvqpmfsv0k0d0l24y4w35krah8mgnwamr0b8spmazz3";
  };

  nativeBuildInputs = [
    autoreconfHook
    which
    sassc
    glib
    libxml2
  ];

  buildInputs = [
    gdk_pixbuf
    librsvg
  ];

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  meta = with stdenv.lib; {
    description = "Grey and blue theme from the Shimmer Project for GTK+-based environments";
    homepage = https://github.com/shimmerproject/Greybird;
    license = with licenses; [ gpl2Plus cc-by-nc-sa-30 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}

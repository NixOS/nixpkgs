{stdenv, fetchurl, imlib2, libX11, libXext }:

stdenv.mkDerivation {
  name = "hsetroot-1.0.2";

  # The primary download site seems to no longer exist; use Gentoo's mirror for now.
  src = fetchurl {
    url = "http://mirror.datapipe.net/gentoo/distfiles/hsetroot-1.0.2.tar.gz";
    sha256 = "d6712d330b31122c077bfc712ec4e213abe1fe71ab24b9150ae2774ca3154fd7";
  };

  buildInputs = [ imlib2 libX11 libXext ];

  meta = {
    description = "hsetroot allows you to compose wallpapers ('root pixmaps') for X";
    homepage = http://thegraveyard.org/hsetroot.html;
    license = stdenv.lib.licenses.gpl2Plus;
  };
}

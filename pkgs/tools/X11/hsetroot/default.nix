{ stdenv, fetchurl, autoconf, automake, imlib2, libtool, libX11, pkgconfig, xorgproto }:

stdenv.mkDerivation rec {
  pname = "hsetroot";
  version = "1.0.2";

  # The primary download site seems to no longer exist; use Gentoo's mirror for now.
  src = fetchurl {
    url = "http://mirror.datapipe.net/gentoo/distfiles/hsetroot-${version}.tar.gz";
    sha256 = "d6712d330b31122c077bfc712ec4e213abe1fe71ab24b9150ae2774ca3154fd7";
  };

  # See https://bugs.gentoo.org/show_bug.cgi?id=504056
  underlinkingPatch = fetchurl {
    url = http://www.gtlib.gatech.edu/pub/gentoo/gentoo-x86-portage/x11-misc/hsetroot/files/hsetroot-1.0.2-underlinking.patch;
    name = "hsetroot-1.0.2-underlinking.patch";
    sha256 = "1px1p3wz7ji725z9nlwb0x0h6lnnvnpz15sblzzq7zrijl3wz65x";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ autoconf automake imlib2 libtool libX11 xorgproto ];

  patches = [ underlinkingPatch ];

  patchFlags = [ "-p0" ];

  preConfigure = "./autogen.sh";

  meta = with stdenv.lib; {
    description = "Allows you to compose wallpapers ('root pixmaps') for X";
    homepage = https://thegraveyard.org/hsetroot.html;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.henrytill ];
    platforms = platforms.unix;
  };
}

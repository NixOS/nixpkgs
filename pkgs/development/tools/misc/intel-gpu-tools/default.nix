{ lib
, stdenv
, fetchurl
, fetchpatch
, pkg-config
, libdrm
, libpciaccess
, cairo
, xorgproto
, udev
, libX11
, libXext
, libXv
, libXrandr
, glib
, bison
, libunwind
, python3
, kmod
, procps
, utilmacros
, gtk-doc
, docbook_xsl
, openssl
, peg
, elfutils
, meson
, ninja
, valgrind
, xmlrpc_c
, gsl
, alsa-lib
, curl
, json_c
, liboping
, flex
, docutils
}:

stdenv.mkDerivation rec {
  pname = "intel-gpu-tools";
  version = "1.26";

  src = fetchurl {
    url = "https://xorg.freedesktop.org/archive/individual/app/igt-gpu-tools-${version}.tar.xz";
    sha256 = "1dwvxh1yplsh1a7h3gpp40g91v12cfxy6yy99s1v9yr2kwxikm1n";
  };

  patches = [
    # fix build with meson 0.60
    (fetchpatch {
      url = "https://github.com/freedesktop/xorg-intel-gpu-tools/commit/963917a3565466832a3b2fc22e9285d34a0bf944.patch";
      sha256 = "sha256-goO2N7aK2dJYMhFGS1DlvjEYMSijN6stV6Q5z/RP8Ko=";
    })
  ];

  nativeBuildInputs = [ pkg-config utilmacros meson ninja flex bison gtk-doc docutils docbook_xsl ];
  buildInputs = [
    libdrm
    libpciaccess
    cairo
    xorgproto
    udev
    libX11
    kmod
    libXext
    libXv
    libXrandr
    glib
    libunwind
    python3
    procps
    openssl
    peg
    elfutils
    valgrind
    xmlrpc_c
    gsl
    alsa-lib
    curl
    json_c
    liboping
  ];

  env.NIX_CFLAGS_COMPILE = toString [ "-Wno-error=array-bounds" ];

  preConfigure = ''
    patchShebangs tests man
  '';

  hardeningDisable = [ "bindnow" ];

  meta = with lib; {
    homepage = "https://01.org/linuxgraphics/";
    description = "Tools for development and testing of the Intel DRM driver";
    license = licenses.mit;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ pSub ];
  };
}

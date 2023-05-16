{ lib
, stdenv
<<<<<<< HEAD
, fetchFromGitLab
, fetchpatch

# build time
, bison
, docbook_xsl
, docutils
, flex
, gtk-doc
, meson
, ninja
, pkg-config
, utilmacros

# runtime
, alsa-lib
, cairo
, curl
, elfutils
, glib
, gsl
, json_c
, kmod
, libdrm
, liboping
, libpciaccess
, libunwind
, libX11
, libXext
, libXrandr
, libXv
, openssl
, peg
, procps
, python3
, udev
, valgrind
, xmlrpc_c
, xorgproto
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "intel-gpu-tools";
<<<<<<< HEAD
  version = "1.27.1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "drm";
    repo = "igt-gpu-tools";
    rev = "refs/tags/v${version}";
    hash = "sha256-7Z9Y7uUjtjdQbB+xV/fvO18xB18VV7fBZqw1fI7U0jQ=";
  };

  patches = [
    # fixes pkgsMusl.intel-gpu-tools
    # https://gitlab.freedesktop.org/drm/igt-gpu-tools/-/issues/138
    (fetchpatch {
      url = "https://raw.githubusercontent.com/void-linux/void-packages/111918317d06598fe1459dbe139923404f3f4b9d/srcpkgs/igt-gpu-tools/patches/musl.patch";
      hash = "sha256-cvtwZg7js7O/Ww7puBTfVzLRji2bHTyV91+PvpH8qrg=";
    })
  ];

  nativeBuildInputs = [
    bison
    docbook_xsl
    docutils
    flex
    gtk-doc
    meson
    ninja
    pkg-config
    utilmacros
  ];

  buildInputs = [
    alsa-lib
    cairo
    curl
    elfutils
    glib
    gsl
    json_c
    kmod
    libdrm
    liboping
    libpciaccess
    libunwind
    libX11
    libXext
    libXrandr
    libXv
    openssl
    peg
    procps
    python3
    udev
    valgrind
    xmlrpc_c
    xorgproto
  ];

=======
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

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  preConfigure = ''
    patchShebangs tests man
  '';

  hardeningDisable = [ "bindnow" ];

  meta = with lib; {
<<<<<<< HEAD
    changelog = "https://gitlab.freedesktop.org/drm/igt-gpu-tools/-/blob/v${version}/NEWS";
    homepage = "https://drm.pages.freedesktop.org/igt-gpu-tools/";
=======
    homepage = "https://01.org/linuxgraphics/";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Tools for development and testing of the Intel DRM driver";
    license = licenses.mit;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ pSub ];
  };
}

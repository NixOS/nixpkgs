{ lib, stdenv, autoconf, automake, fetchFromGitHub, fetchpatch
, libjpeg_turbo
, libpng, libtool, libxml2, pkg-config, which, xorg
, libtirpc
}:
stdenv.mkDerivation rec {
  pname = "nx-libs";
  version = "3.5.99.26";
  src = fetchFromGitHub {
    owner = "ArcticaProject";
    repo = "nx-libs";
    rev = version;
    sha256 = "sha256-qVOdD85sBMxKYx1cSLAGKeODsKKAm9UPBmYzPBbBOzQ=";
  };

  patches = [
    (fetchpatch {
      name = "binutils-2.36.patch";
      url = "https://github.com/ArcticaProject/nx-libs/commit/605a266911b50ababbb3f8a8b224efb42743379c.patch";
      sha256 = "sha256-kk5ms3i0PrHL74I4OlsqDrdDcCJ0us03cQcBy4zjAoQ=";
    })
  ];

  nativeBuildInputs = [ autoconf automake libtool pkg-config which
    xorg.gccmakedep xorg.imake ];
  buildInputs = [ libjpeg_turbo libpng libxml2 xorg.fontutil
    xorg.libXcomposite xorg.libXdamage xorg.libXdmcp xorg.libXext xorg.libXfont2
    xorg.libXinerama xorg.libXpm xorg.libXrandr xorg.libXtst xorg.pixman
    xorg.xkbcomp xorg.xkeyboardconfig libtirpc
  ];

  env.NIX_CFLAGS_COMPILE = toString [ "-I${libtirpc.dev}/include/tirpc" ];
  NIX_LDFLAGS = [ "-ltirpc" ];

  postPatch = ''
    patchShebangs .
    find . -type f -name Makefile -exec sed -i 's|^\(SHELL:=\)/bin/bash$|\1${stdenv.shell}|g' {} \;
    ln -s libNX_X11.so.6.3.0
  '';

  preConfigure = ''
    # binutils 2.37 fix
    # https://github.com/ArcticaProject/nx-libs/issues/1003
    substituteInPlace nx-X11/config/cf/Imake.tmpl --replace "clq" "cq"
  '';

  PREFIX=""; # Don't install to $out/usr/local
  installPhase = ''
    make DESTDIR="$out" install
    # See:
    # - https://salsa.debian.org/debian-remote-team/nx-libs/blob/bcc152100617dc59156015a36603a15db530a64f/debian/rules#L66-72
    # - https://github.com/ArcticaProject/nx-libs/issues/652
    patchelf --remove-needed "libX11.so.6" $out/bin/nxagent
  '';

  meta = {
    description = "NX X server based on Xnest";
    homepage = "https://github.com/ArcticaProject/nx-libs";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
}

{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
  xorgproto,
  libX11,
  libXext,
  libXi,
  libXinerama,
  libXrandr,
  libXrender,
  ncurses,
  pixman,
  pkg-config,
  udev,
  utilmacros,
  xorgserver,
}:

stdenv.mkDerivation rec {
  pname = "xf86-input-wacom";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "linuxwacom";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "sha256-3w12OjjMdu03BhUVEjkyj1ngDFnp0Cp66L0nn3LuU8Q=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libX11
    libXext
    libXi
    libXinerama
    libXrandr
    libXrender
    ncurses
    udev
    utilmacros
    pixman
    xorgproto
    xorgserver
  ];

  configureFlags = [
    "--with-xorg-module-dir=${placeholder "out"}/lib/xorg/modules"
    "--with-sdkdir=${placeholder "out"}/include/xorg"
    "--with-xorg-conf-dir=${placeholder "out"}/share/X11/xorg.conf.d"
  ];

  meta = with lib; {
    maintainers = with maintainers; [
      goibhniu
      moni
    ];
    description = "Wacom digitizer driver for X11";
    homepage = "https://linuxwacom.sourceforge.net";
    license = licenses.gpl2Only;
    platforms = platforms.linux; # Probably, works with other unixes as well
  };
}

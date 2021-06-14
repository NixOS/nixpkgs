{ lib
, stdenv
, autoreconfHook
, fetchFromGitHub
, xorgproto
, libX11
, libXext
, libXi
, libXinerama
, libXrandr
, libXrender
, ncurses
, pixman
, pkg-config
, udev
, utilmacros
, xorgserver
}:

stdenv.mkDerivation rec {
  pname = "xf86-input-wacom";
  version = "0.40.0";

  src = fetchFromGitHub {
    owner = "linuxwacom";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "sha256-0U4pAB5vsIlBewCBqQ4SLHDrwqtr9nh7knZpXZMkzck=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

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

  preConfigure = ''
    mkdir -p $out/share/X11/xorg.conf.d
    configureFlags="--with-xorg-module-dir=$out/lib/xorg/modules
    --with-sdkdir=$out/include/xorg --with-xorg-conf-dir=$out/share/X11/xorg.conf.d"
  '';

  CFLAGS = "-I${pixman}/include/pixman-1";

  meta = with lib; {
    maintainers = with maintainers; [ goibhniu fortuneteller2k ];
    description = "Wacom digitizer driver for X11";
    homepage = "http://linuxwacom.sourceforge.net";
    license = licenses.gpl2Only;
    platforms = platforms.linux; # Probably, works with other unixes as well
  };
}

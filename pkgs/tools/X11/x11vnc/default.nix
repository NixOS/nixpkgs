{ lib, stdenv, fetchFromGitHub, fetchpatch,
  openssl, zlib, libjpeg, xorg, coreutils, libvncserver,
  autoreconfHook, pkg-config }:

stdenv.mkDerivation rec {
  pname = "x11vnc";
  version = "0.9.16";

  src = fetchFromGitHub {
    owner = "LibVNC";
    repo = "x11vnc";
    rev = version;
    sha256 = "1g652mmi79pfq4p5p7spaswa164rpzjhc5rn2phy5pm71lm0vib1";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2020-29074.patch";
      url = "https://github.com/LibVNC/x11vnc/commit/69eeb9f7baa14ca03b16c9de821f9876def7a36a.patch";
      sha256 = "0hdhp32g2i5m0ihmaxkxhsn3d5f2qasadvwpgxify4xnzabmyb2d";
    })

    # Pull upstream fix for -fno-common toolchains:
    #   https://github.com/LibVNC/x11vnc/pull/121
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/LibVNC/x11vnc/commit/a48b0b1cd887d7f3ae67f525d7d334bd2feffe60.patch";
      sha256 = "046gjsmg0vm0m4y9ny17y2jayc4ba7vib2whw71l5x1hjp6pksjs";
    })
  ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs =
    [ xorg.libXfixes xorg.xorgproto openssl xorg.libXdamage
      zlib xorg.libX11 libjpeg
      xorg.libXtst xorg.libXinerama xorg.libXrandr
      xorg.libXext
      xorg.libXi xorg.libXrender
      libvncserver
    ];

  postPatch = ''
    substituteInPlace src/unixpw.c \
        --replace '"/bin/su"' '"/run/wrappers/bin/su"' \
        --replace '"/bin/true"' '"${coreutils}/bin/true"'

    sed -i -e '/#!\/bin\/sh/a"PATH=${xorg.xdpyinfo}\/bin:${xorg.xauth}\/bin:$PATH\\n"' -e 's|/bin/su|/run/wrappers/bin/su|g' src/ssltools.h

    # Xdummy script is currently broken, so we avoid building it. This removes everything Xdummy-related from the affected Makefile
    sed -i -e '/^\tXdummy.c\ \\$/,$d' -e 's/\tx11vnc_loop\ \\/\tx11vnc_loop/' misc/Makefile.am
  '';

  meta = with lib; {
    description = "A VNC server connected to a real X11 screen";
    homepage = "https://github.com/LibVNC/x11vnc/";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ OPNA2608 ];
  };
}

{ lib, stdenv, fetchurl, libXt, libXaw, libXtst
, libXi, libXpm, pkg-config, xorgproto, Xaw3d }:

stdenv.mkDerivation rec {
  pname = "xvkbd";
  version = "4.1";
  src = fetchurl {
    url = "http://t-sato.in.coocan.jp/xvkbd/xvkbd-${version}.tar.gz";
    sha256 = "1x5yldv9y99cw5hzzs73ygdn1z80zns9hz0baa355r711zghfbcm";
  };

  nativeBuildInputs = [ pkg-config ] ;
  buildInputs = [ libXt libXaw libXtst xorgproto libXi Xaw3d libXpm ];

  makeFlags = [
    # avoid default libXt location
    "appdefaultdir=${placeholder "out"}/share/X11/app-defaults"
    "datarootdir=${placeholder "out"}/share"
  ];

  preInstall = ''
    # workaround absence of libXt in $DESTDIR location.
    mkdir -p $out/share/X11
  '';

  meta = with lib; {
    description = "Virtual keyboard for X window system";
    longDescription = ''
      xvkbd is a virtual (graphical) keyboard program for X Window System which provides
      facility to enter characters onto other clients (softwares) by clicking on a
      keyboard displayed on the screen.
    '';
    homepage = "http://t-sato.in.coocan.jp/xvkbd";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.bennofs ];
    platforms = platforms.linux;
  };
}

{ stdenv, fetchurl, imake, libXt, libXaw, libXtst, libXi, libXpm, xextproto, gccmakedep, Xaw3d }:

stdenv.mkDerivation rec {
  name = "xvkbd-${version}";
  version = "3.7";
  src = fetchurl {
    url = "http://homepage3.nifty.com/tsato/xvkbd/xvkbd-${version}.tar.gz";
    sha256 = "02y9ks9sa4sn3vkbgswjs5qcd85xhwvarnmhg41pq3l2d617cpw9";
  };

  buildInputs = [ imake libXt libXaw libXtst xextproto libXi Xaw3d libXpm gccmakedep ];
  installTargets = [ "install" "install.man" ];
  preBuild = ''
    makeFlagsArray=( BINDIR=$out/bin XAPPLOADDIR=$out/etc/X11/app-defaults MANPATH=$out/man )
  '';
  configurePhase = '' xmkmf -a '';

  meta = with stdenv.lib; {
    description = "Virtual keyboard for X window system";
    longDescription = ''
      xvkbd is a virtual (graphical) keyboard program for X Window System which provides
      facility to enter characters onto other clients (softwares) by clicking on a
      keyboard displayed on the screen.
    '';
    homepage = http://homepage3.nifty.com/tsato/xvkbd/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.bennofs ];
    platforms = platforms.linux;
  };
}

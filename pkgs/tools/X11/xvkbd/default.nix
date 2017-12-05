{ stdenv, fetchurl, imake, libXt, libXaw, libXtst, libXi, libXpm, xextproto, gccmakedep, Xaw3d }:

stdenv.mkDerivation rec {
  name = "xvkbd-${version}";
  version = "3.8";
  src = fetchurl {
    url = "http://t-sato.in.coocan.jp/xvkbd/xvkbd-3.8.tar.gz";
    sha256 = "16r5wbb5za02ha0ilwswx37lrwa6j40px8c9gkpnmmpb5r7kv91c";
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

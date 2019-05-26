{ stdenv, fetchurl, imake, libXt, libXaw, libXtst
, libXi, libXpm, xorgproto, gccmakedep, Xaw3d }:

stdenv.mkDerivation rec {
  name = "xvkbd-${version}";
  version = "3.9";
  src = fetchurl {
    url = "http://t-sato.in.coocan.jp/xvkbd/xvkbd-3.9.tar.gz";
    sha256 = "17csj6x5zm3g67izfwhagkal1rbqzpw09lqmmlyrjy3vzgfkf75q";
  };

  nativeBuildInputs = [ imake gccmakedep ];
  buildInputs = [ libXt libXaw libXtst xorgproto libXi Xaw3d libXpm ];
  installTargets = [ "install" "install.man" ];
  makeFlags = [
    "BINDIR=$(out)/bin"
    "XAPPLOADDIR=$(out)/etc/X11/app-defaults"
    "MANPATH=$(out)/man"
  ];

  meta = with stdenv.lib; {
    description = "Virtual keyboard for X window system";
    longDescription = ''
      xvkbd is a virtual (graphical) keyboard program for X Window System which provides
      facility to enter characters onto other clients (softwares) by clicking on a
      keyboard displayed on the screen.
    '';
    homepage = http://t-sato.in.coocan.jp/xvkbd;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.bennofs ];
    platforms = platforms.linux;
  };
}

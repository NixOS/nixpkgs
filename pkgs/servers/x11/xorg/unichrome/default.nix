{stdenv, fetchgit, pkgconfig, fontsproto, libdrm, libpciaccess, randrproto, renderproto,
videoproto, libX11,
xextproto, xf86driproto, xorgserver, xproto, libXvMC, glproto, mesa, automake,
autoconf, libtool, libXext, utilmacros}:

stdenv.mkDerivation {
  name = "xf86-video-unichrome-git";
  src = fetchgit {
    url = http://svn.openchrome.org/svn/trunk;
    md5 = "6e5e0f8ee204af2385a02e502d1ca8f1";
    rev = "6260e0fc9f0754d101dda014a8f4b5f76f58e978";
  };
  buildInputs = [pkgconfig fontsproto libdrm libpciaccess randrproto renderproto
    videoproto libX11 libXext xextproto xf86driproto xorgserver xproto libXvMC
    glproto mesa automake autoconf libtool libXext utilmacros ];
  preConfigure = "chmod +x autogen.sh";
  prePatch = ''
    sed s,/bin/bash,/bin/sh, -i git_version.sh
  '';
  patches = [ ./configure.patch ];
  configureScript = "./autogen.sh";

  meta = {
    homepage = "http://unichrome.sourceforge.net/";
    description = "Xorg video driver for the S3 Unichrome family of integrated graphics devices";
    license = "free";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}

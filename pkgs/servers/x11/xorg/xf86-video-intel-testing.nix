{ stdenv, fetchurl, pkgconfig, libdrm, udev, xorg }:

with xorg;

(stdenv.mkDerivation ({
  name = "xf86-video-intel-2.99.911";
  builder = ./builder.sh;
  src = fetchurl {
    url = mirror://xorg/individual/driver/xf86-video-intel-2.99.911.tar.bz2;
    sha256 = "1mkhfa10304xvs763dz1kj93zkmdidlfxhsy5j8ljkfc3d4nhyjf";
  };
  buildInputs = [pkgconfig dri2proto fontsproto glamoregl libdrm udev libpciaccess randrproto renderproto libX11 xcbutil libxcb libXcursor libXdamage libXext xextproto xf86driproto libXfixes libXinerama xorgserver xproto libXrandr libXrender libXtst libXvMC ];
})) // {inherit dri2proto fontsproto glamoregl libdrm udev libpciaccess randrproto renderproto libX11 xcbutil libxcb libXcursor libXdamage libXext xextproto xf86driproto libXfixes libXinerama xorgserver xproto libXrandr libXrender libXtst libXvMC ;}


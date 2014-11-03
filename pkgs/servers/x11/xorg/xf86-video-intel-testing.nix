{ stdenv, fetchurl, pkgconfig, libdrm, udev, xorg }:

with xorg;

(stdenv.mkDerivation ({
  name = "xf86-video-intel-2.99.912";
  builder = ./builder.sh;
  src = fetchurl {
    url = mirror://xorg/individual/driver/xf86-video-intel-2.99.912.tar.bz2;
    sha256 = "00cmvs5jxaqnl1pwqvj1rwir4kbvf5qfng89cjn4rwsr5m4zr3vw";
  };
  buildInputs = [pkgconfig dri2proto fontsproto glamoregl libdrm udev libpciaccess randrproto renderproto libX11 xcbutil libxcb libXcursor libXdamage libXext xextproto xf86driproto libXfixes libXinerama xorgserver xproto libXrandr libXrender libXtst libXvMC ];
})) // {inherit dri2proto fontsproto glamoregl libdrm udev libpciaccess randrproto renderproto libX11 xcbutil libxcb libXcursor libXdamage libXext xextproto xf86driproto libXfixes libXinerama xorgserver xproto libXrandr libXrender libXtst libXvMC ;}


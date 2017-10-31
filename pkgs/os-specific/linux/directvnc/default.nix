{ stdenv, fetchurl, pkgconfig, directfb, zlib, libjpeg, xproto }:

stdenv.mkDerivation rec {
  name="directvnc-${version}";
  version="0.7.5-test-051207";

  src = fetchurl {
    url = "http://directvnc-rev.googlecode.com/files/directvnc-${version}.tar.gz";
    sha256 = "1is9hca8an1b1n8436wkv7s08ml5lb95f7h9vznx9br597f106w9";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    directfb zlib libjpeg xproto
  ];
      
  meta = {
    description = "DirectFB VNC client";
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = with stdenv.lib.platforms; linux;
  };
}

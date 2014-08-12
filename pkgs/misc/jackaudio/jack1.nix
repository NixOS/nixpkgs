{ stdenv, fetchurl, pkgconfig, alsaLib, db, libuuid
, firewireSupport ? false, ffado ? null }:

assert firewireSupport -> ffado != null;

stdenv.mkDerivation rec {
  name = "jack1-${version}";
  version = "0.124.1";

  src = fetchurl {
    url = "http://jackaudio.org/downloads/jack-audio-connection-kit-${version}.tar.gz";
    sha256 = "1mk1wnx33anp6haxfjjkfhwbaknfblsvj35nxvz0hvspcmhdyhpb";
  };
  
  preBuild = "echo ok";

  configureFlags = ''
    ${if firewireSupport then "--enable-firewire" else ""}
  '';

  buildInputs = 
    [ pkgconfig alsaLib db libuuid
    ] ++ (stdenv.lib.optional firewireSupport ffado);
  
  meta = {
    description = "JACK audio connection kit";
    homepage = "http://jackaudio.org";
    license = "GPL";
  };
}

{ stdenv, fetchurl, pkgconfig, alsaLib
, firewireSupport ? false, ffado ? null }:

assert firewireSupport -> ffado != null;

stdenv.mkDerivation rec {
  name = "jack-${version}";
  version = "0.121.3";

  src = fetchurl {
    url = "http://jackaudio.org/downloads/jack-audio-connection-kit-${version}.tar.gz";
    sha256 = "1ypa3gjwy4vmaskin0vczmmdwybckkl42wmkfabx3v5yx8yms2dp";
  };
  
  preBuild = "echo ok";

  configureFlags = ''
    ${if firewireSupport then "--enable-firewire" else ""}
  '';

  buildInputs = 
    [ pkgconfig alsaLib
    ] ++ (stdenv.lib.optional firewireSupport ffado);
  
  meta = {
    description = "JACK audio connection kit";
    homepage = "http://jackaudio.org";
    license = "GPL";
  };
}

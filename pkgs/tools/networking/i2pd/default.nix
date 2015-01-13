{ stdenv, fetchurl, boost, cryptopp }:

stdenv.mkDerivation rec {

  name = "i2pd-${version}";
  version = "0.6.0";

  src = fetchurl {
    url = "https://github.com/PrivacySolutions/i2pd/archive/${version}.tar.gz";
    sha256 = "1dy3yw2x5smmnb9jna5fi4yqp5lydj8fqvm0ms43kg0fhwnqr6hl";
  };

  buildInputs = [ boost cryptopp ];
  installPhase = ''
    install -D i2p $out/bin/i2p
  '';

  meta = with stdenv.lib; {
    homepage = "https://track.privacysolutions.no/projects/i2pd";
    description = "Minimal I2P router written in C++";
    licenses = licenses.gpl2;
    maintainers = with maintainers; [ edwtjo ];
    platform = platforms.linux;
  };
}
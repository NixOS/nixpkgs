{ stdenv, fetchurl, boost, cryptopp }:

stdenv.mkDerivation rec {

  name = "i2pd-${version}";
  version = "0.4.0";

  src = fetchurl {
    url = "https://github.com/PrivacySolutions/i2pd/archive/${version}.tar.gz";
    sha256 = "1gab0ams8bwkiwq0wjiclkm5ms5m5p3x06gzhi2dpdc6vbdkzmlp";
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
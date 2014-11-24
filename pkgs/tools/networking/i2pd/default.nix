{ stdenv, fetchurl, boost, cryptopp }:

stdenv.mkDerivation rec {

  name = "i2pd-${version}";
  version = "0.3.0";

  src = fetchurl {
    url = "https://github.com/PrivacySolutions/i2pd/archive/v${version}-1stbinrelease.tar.gz";
    sha256 = "015y5v6w1mmzmnylfdc1l3r4qbmax3nywyz0r0pd651xgvvvinrv";
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
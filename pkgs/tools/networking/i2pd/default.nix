{ stdenv, fetchurl, boost, cryptopp }:

stdenv.mkDerivation rec {

  name = "i2pd-${version}";
  version = "0.9.0";

  src = fetchurl {
    name = "i2pd-src-${version}.tar.gz";
    url = "https://github.com/PurpleI2P/i2pd/archive/${version}.tar.gz";
    sha256 = "1rcf4wc34g2alva9jzj6bz0f88g2f5v1w4418b6lp6chvqi7fhc7";
  };

  buildInputs = [ boost cryptopp ];
  installPhase = ''
    install -D i2p $out/bin/i2p
  '';

  meta = with stdenv.lib; {
    homepage = "https://track.privacysolutions.no/projects/i2pd";
    description = "Minimal I2P router written in C++";
    license = licenses.gpl2;
    maintainers = with maintainers; [ edwtjo ];
    platforms = platforms.linux;
  };
}

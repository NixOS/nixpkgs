{ stdenv, fetchurl, boost, cryptopp }:

stdenv.mkDerivation rec {

  name = "i2pd-${version}";
  version = "0.8.0";

  src = fetchurl {
    name = "i2pd-src-${version}.tar.gz";
    url = "https://github.com/PurpleI2P/i2pd/archive/${version}.tar.gz";
    sha256 = "1vw6s480lmxwhq0rx6d2lczb6d2j9f68hmv3ri9jwgp7bicy6ziz";
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
    platforms = platforms.linux;
  };
}

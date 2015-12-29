{ stdenv, fetchFromGitHub, fetchpatch, boost, zlib, openssl }:

stdenv.mkDerivation rec {

  name = pname + "-" + version;
  pname = "i2pd";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "PurpleI2P";
    repo = pname;
    rev = version;
    sha256 = "0slrfmgrf9b689wpsdpvsnmhbqsygcy558dz259k6xcf50f7lfqh";
  };

  buildInputs = [ boost zlib openssl ];
  makeFlags = "USE_AESNI=no";

  installPhase = ''
    install -D i2pd $out/bin/i2pd
  '';

  meta = with stdenv.lib; {
    homepage = "https://track.privacysolutions.no/projects/i2pd";
    description = "Minimal I2P router written in C++";
    license = licenses.gpl2;
    maintainers = with maintainers; [ edwtjo ];
    platforms = platforms.linux;
  };
}

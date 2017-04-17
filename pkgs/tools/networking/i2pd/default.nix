{ stdenv, fetchFromGitHub, fetchpatch, boost, zlib, openssl }:

stdenv.mkDerivation rec {

  name = pname + "-" + version;
  pname = "i2pd";
  version = "2.12.0";

  src = fetchFromGitHub {
    owner = "PurpleI2P";
    repo = pname;
    rev = version;
    sha256 = "1m97s3c1fvhq6ql3zr2a2ia2n06cl8jgf28gjn4k3xg8m7s984dz";
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

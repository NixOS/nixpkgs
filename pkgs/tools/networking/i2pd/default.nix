{ stdenv, fetchFromGitHub, fetchpatch, boost, zlib, openssl }:

stdenv.mkDerivation rec {

  name = pname + "-" + version;
  pname = "i2pd";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "PurpleI2P";
    repo = pname;
    rev = version;
    sha256 = "06y6pi0wlxpasncm4qq30sh0cavwl2f4gdz0hss70if8mr6z9hyq";
  };

  buildInputs = [ boost zlib openssl ];
  makeFlags = "USE_AESNI=no";
  patches = [ (fetchpatch {
    url = https://github.com/PurpleI2P/i2pd/commit/4109ab1590791f3c1bf4e9eceec2d43be7b5ea47.patch;
    sha256 = "17zg9iah59icy8nn1nwfnsnbzpafgrsasz1pmb2q4iywb7wbnkzi";
  }) ];

  installPhase = ''
    install -D i2p $out/bin/i2pd
  '';

  meta = with stdenv.lib; {
    homepage = "https://track.privacysolutions.no/projects/i2pd";
    description = "Minimal I2P router written in C++";
    license = licenses.gpl2;
    maintainers = with maintainers; [ edwtjo ];
    platforms = platforms.linux;
  };
}

{ stdenv, fetchFromGitHub, fetchpatch, boost, zlib, openssl }:

stdenv.mkDerivation rec {

  name = pname + "-" + version;
  pname = "i2pd";
  version = "2.14.0";

  src = fetchFromGitHub {
    owner = "PurpleI2P";
    repo = pname;
    rev = version;
    sha256 = "1nlnzvb4n351zwg4vd15qjmm8xvbmn2350vfnd249q06va62fqjk";
  };

  buildInputs = [ boost zlib openssl ];
  makeFlags = [ "USE_AESNI=no" "USE_AVX=no" ];

  installPhase = ''
    install -D i2pd $out/bin/i2pd
  '';

  meta = with stdenv.lib; {
    homepage = https://i2pd.website;
    description = "Minimal I2P router written in C++";
    license = licenses.gpl2;
    maintainers = with maintainers; [ edwtjo ];
    platforms = platforms.linux;
  };
}

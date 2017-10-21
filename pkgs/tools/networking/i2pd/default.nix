{ stdenv, fetchFromGitHub, fetchpatch, boost, zlib, openssl }:

stdenv.mkDerivation rec {

  name = pname + "-" + version;
  pname = "i2pd";
  version = "2.15.0";

  src = fetchFromGitHub {
    owner = "PurpleI2P";
    repo = pname;
    rev = version;
    sha256 = "02nyk76q2ag0495ph62i0jij27nxpy6qvryjp25wah8f69k7bgfs";
  };

  buildInputs = [ boost zlib openssl ];
  makeFlags = [ "USE_AESNI=no" "USE_AVX=no" ];

  installPhase = ''
    install -D i2pd $out/bin/i2pd
  '';

  meta = with stdenv.lib; {
    homepage = https://i2pd.website;
    description = "Minimal I2P router written in C++";
    license = licenses.bsd3;
    maintainers = with maintainers; [ edwtjo ];
    platforms = platforms.linux;
  };
}

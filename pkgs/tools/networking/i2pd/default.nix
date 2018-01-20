{ stdenv, fetchFromGitHub, fetchpatch, boost, zlib, openssl }:

stdenv.mkDerivation rec {

  name = pname + "-" + version;
  pname = "i2pd";
  version = "2.17.0";

  src = fetchFromGitHub {
    owner = "PurpleI2P";
    repo = pname;
    rev = version;
    sha256 = "1yl5h7mls50vkg7x5510mljmgsm02arqhcanwkrqw4ilwvcp1mgz";
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

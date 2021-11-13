{ lib, stdenv, fetchFromGitHub, bison, libressl, libevent }:

stdenv.mkDerivation rec {
  pname = "gmid";
  version = "1.7.5";

  src = fetchFromGitHub {
    owner = "omar-polo";
    repo = pname;
    rev = version;
    sha256 = "sha256-BBd0AL5jRRslxzDnxcTZRR+8J5D23NAQ7mp9K+leXAQ=";
  };

  nativeBuildInputs = [ bison ];

  buildInputs = [ libressl libevent ];

  configurePhase = ''
    runHook preConfigure
    ./configure PREFIX=$out
    runHook postConfigure
  '';

  meta = with lib; {
    description = "Simple and secure Gemini server";
    homepage = "https://gmid.omarpolo.com/";
    license = licenses.isc;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.linux;
  };
}

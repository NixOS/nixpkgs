{ lib, stdenv, fetchFromGitHub, fetchpatch, bison, libressl, libevent }:

stdenv.mkDerivation rec {
  pname = "gmid";
  version = "1.7.5";

  src = fetchFromGitHub {
    owner = "omar-polo";
    repo = pname;
    rev = version;
    sha256 = "sha256-BBd0AL5jRRslxzDnxcTZRR+8J5D23NAQ7mp9K+leXAQ=";
  };

  patches = [
    # Fix cross-compilation
    (fetchpatch {
      url = "https://github.com/omar-polo/gmid/commit/eb77afa8d308a2f4f422df2ff19f023b5b2cc591.patch";
      sha256 = "sha256-rTTZUpfXOg7X0Ad0Y9evyU7k+aVYpJ0t9SEkNA/sSdk=";
    })
  ];

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

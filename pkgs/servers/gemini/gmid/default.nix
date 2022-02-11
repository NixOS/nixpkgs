{ lib, stdenv, fetchFromGitHub, fetchpatch, bison, libressl, libevent }:

stdenv.mkDerivation rec {
  pname = "gmid";
  version = "1.8";

  src = fetchFromGitHub {
    owner = "omar-polo";
    repo = pname;
    rev = version;
    sha256 = "sha256-CwJPaZefRDyn2fliOd9FnOLXq70HFu2RsUZhzWQdE3E";
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

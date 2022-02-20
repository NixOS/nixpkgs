{ lib, stdenv, fetchFromGitHub, bison, which, libressl, libevent }:

stdenv.mkDerivation rec {
  pname = "gmid";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "omar-polo";
    repo = pname;
    rev = version;
    hash = "sha256-XNif164C5b5sVsZW7sy0id4qM/mJzg3RhoHbwJuJqDk=";
  };

  nativeBuildInputs = [ bison which ];

  buildInputs = [ libressl libevent ];

  configureFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "Simple and secure Gemini server";
    homepage = "https://gmid.omarpolo.com/";
    license = licenses.isc;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.linux;
  };
}

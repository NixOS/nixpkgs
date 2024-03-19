{ lib, stdenv, fetchFromGitHub, bison, libressl, libevent }:

stdenv.mkDerivation rec {
  pname = "gmid";
  version = "1.8.6";

  src = fetchFromGitHub {
    owner = "omar-polo";
    repo = pname;
    rev = version;
    hash = "sha256-ds5k5VHwc7/sq4PUe/WvxAx7gJkU4phKZk0KunPLNE0=";
  };

  nativeBuildInputs = [ bison ];

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

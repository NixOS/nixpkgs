{ lib
, stdenv
, fetchFromGitHub
, jansson
, rsync
, curl
, libxml2
, pkg-config
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "fort-validator";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "NICMx";
    repo = "FORT-validator";
    rev = "v${version}";
    sha256 = "sha256-sldN/xg+agdunTln2q03XEjSwyDtDJucv+9YizP4nw8=";
  };

  buildInputs = [
    jansson
    rsync
    curl
    libxml2
  ];

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  meta = with lib; {
    description = "An RPKI Validator and RTR Server, part of the FORT project";
    homepage = "https://fortproject.net/en/validator";
    license = licenses.mit;
    maintainers = with maintainers; [ citadelcore ];
  };
}

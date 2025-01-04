{ lib, stdenv
, fetchFromGitHub
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "readexe";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "segin";
    repo = "readexe";
    rev = "v${version}";
    hash = "sha256-ba4nm7jTl622apsJheYcWle4luEzzstA9DJs1Ghj678=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    description = "Reads out structural information on Microsoft .exe formats";
    homepage = "https://github.com/segin/readexe";
    license = with licenses; [ isc bsd3 ];
    maintainers = with maintainers; [ evils ];
  };
}

{ lib
, stdenv
, fetchFromSourcehut
, SDL2
}:

stdenv.mkDerivation rec {
  pname = "clickclack";
  version = "0.2";

  src = fetchFromSourcehut {
    owner = "~proycon";
    repo = "clickclack";
    rev = version;
    sha256 = "sha256-hldtHSRdw6yP9lUFna5yvJ3mOTbQbbQNnGM7fMQmmtM=";
  };

  buildInputs = [
    SDL2
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "A vibration/audio feedback tool to be used with virtual keyboards";
    homepage = "https://git.sr.ht/~proycon/clickclack";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dotlambda ];
  };
}

{ lib
, stdenv
, fetchFromSourcehut
, SDL2
}:

stdenv.mkDerivation rec {
  pname = "clickclack";
  version = "0.1.1";

  src = fetchFromSourcehut {
    owner = "~proycon";
    repo = "clickclack";
    rev = version;
    sha256 = "1q8r0ng1bld5n82gh7my7ck90f4plf8vf019hm2wz475dl38izd5";
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

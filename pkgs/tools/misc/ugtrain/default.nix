{ lib, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, scanmem
}:

stdenv.mkDerivation rec {
  version = "0.4.1";
  pname = "ugtrain";

  src = fetchFromGitHub {
    owner  = "ugtrain";
    repo   = "ugtrain";
    rev    = "v${version}";
    sha256 = "0pw9lm8y83mda7x39874ax2147818h1wcibi83pd2x4rp1hjbkkn";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config scanmem ];

  meta = with lib; {
    homepage = "https://github.com/ugtrain/ugtrain";
    description = "The Universal Elite Game Trainer for CLI (Linux game trainer research project)";
    maintainers = with maintainers; [ mtrsk ];
    platforms = platforms.linux;
    license = licenses.gpl3Only;
  };
}

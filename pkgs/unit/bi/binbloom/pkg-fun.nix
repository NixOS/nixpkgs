{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "binbloom";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "quarkslab";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-UiKiDey/pHtJDr4UYqt+T/TneKig5tT8YU2u98Ttjmo=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    description = "Raw binary firmware analysis software";
    homepage = "https://github.com/quarkslab/binbloom";
    license = licenses.asl20;
    maintainers = with maintainers; [ erdnaxe ];
    platforms = platforms.linux;
  };
}

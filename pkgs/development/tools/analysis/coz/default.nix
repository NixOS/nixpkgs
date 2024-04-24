{ lib
, stdenv
, docutils
, fetchFromGitHub
, libelfin
, ncurses
, pkg-config
, python3
}:
stdenv.mkDerivation rec {
  pname = "coz";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "plasma-umass";
    repo = "coz";
    rev = version;
    hash = "sha256-tvFXInxjodB0jEgEKgnOGapiVPomBG1hvrhYtG2X5jI=";
  };

  postPatch = ''
    substituteInPlace coz --replace-warn "python2.7" "python3"
  '';

  nativeBuildInputs = [
    docutils
    ncurses # tput
    pkg-config
  ];

  buildInputs = [
    libelfin
    python3
  ];

  makeFlags = [ "prefix=${placeholder "out"}" ];

  meta = {
    homepage = "https://github.com/plasma-umass/coz";
    description = "Profiler based on casual profiling";
    mainProgram = "coz";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ zimbatm ];
  };
}

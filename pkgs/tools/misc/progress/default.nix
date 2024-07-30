{ lib, stdenv, fetchFromGitHub, pkg-config, ncurses, which }:

stdenv.mkDerivation rec {
  pname = "progress";
  version = "0.17";

  src = fetchFromGitHub {
    owner = "Xfennec";
    repo = "progress";
    rev = "v${version}";
    sha256 = "sha256-riewkageSZIlwDNMjYep9Pb2q1GJ+WMXazokJGbb4bE=";
  };

  nativeBuildInputs = [ pkg-config which ];
  buildInputs = [ ncurses ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/Xfennec/progress";
    description = "Tool that shows the progress of coreutils programs";
    license = licenses.gpl3;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ pSub ];
    mainProgram = "progress";
  };
}

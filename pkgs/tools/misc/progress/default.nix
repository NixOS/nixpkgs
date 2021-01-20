{ lib, stdenv, fetchFromGitHub, pkg-config, ncurses, which }:

stdenv.mkDerivation rec {
  pname = "progress";
  version = "0.15";

  src = fetchFromGitHub {
    owner = "Xfennec";
    repo = "progress";
    rev = "v${version}";
    sha256 = "1cnb4ixlhshn139mj5sr42k5m6gjjbyqvkn1324c47niwrgp7dqm";
  };

  nativeBuildInputs = [ pkg-config which ];
  buildInputs = [ ncurses ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/Xfennec/progress";
    description = "Tool that shows the progress of coreutils programs";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}

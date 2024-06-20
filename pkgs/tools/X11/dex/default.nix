{ lib
, stdenv
, fetchFromGitHub
, python3
, sphinx
}:

stdenv.mkDerivation rec {
  pname = "dex";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "jceb";
    repo = pname;
    rev = "v${version}";
    sha256 = "03aapcywnz4kl548cygpi25m8adwbmqlmwgxa66v4156ax9dqs86";
  };

  strictDeps = true;

  nativeBuildInputs = [ sphinx ];
  buildInputs = [ python3 ];
  makeFlags = [ "PREFIX=$(out)" "VERSION=$(version)" ];

  meta = with lib; {
    description = "Program to generate and execute DesktopEntry files of the Application type";
    homepage = "https://github.com/jceb/dex";
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ nickcao ];
    mainProgram = "dex";
  };
}

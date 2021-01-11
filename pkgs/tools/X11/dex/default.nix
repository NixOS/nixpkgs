{ lib, stdenv, fetchFromGitHub, python3 }:

stdenv.mkDerivation rec {
  program = "dex";
  name = "${program}-${version}";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "jceb";
    repo = program;
    rev = "v${version}";
    sha256 = "03aapcywnz4kl548cygpi25m8adwbmqlmwgxa66v4156ax9dqs86";
  };

  propagatedBuildInputs = [ python3 ];
  nativeBuildInputs = [ python3.pkgs.sphinx ];
  makeFlags = [ "PREFIX=$(out)" "VERSION=$(version)" ];

  meta = with lib; {
    description = "A program to generate and execute DesktopEntry files of the Application type";
    homepage = "https://github.com/jceb/dex";
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
  };
}

{ stdenv, fetchFromGitHub, python3 }:

stdenv.mkDerivation rec {
  program = "dex";
  name = "${program}-${version}";
  version = "0.7";

  src = fetchFromGitHub {
    owner = "jceb";
    repo = program;
    rev = "v${version}";
    sha256 = "041ms01snalapapaniabr92d8iim1qrxian626nharjmp2rd69v5";
  };

  propagatedBuildInputs = [ python3 ];
  makeFlags = [ "PREFIX=$(out)" "VERSION=$(version)" ];

  meta = {
    description = "A program to generate and execute DesktopEntry files of the Application type";
    homepage = https://github.com/jceb/dex;
    platforms = stdenv.lib.platforms.linux;
  };
}

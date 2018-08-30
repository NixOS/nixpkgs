{ stdenv, fetchFromGitHub, python3 }:

stdenv.mkDerivation rec {
  program = "dex";
  name = "${program}-${version}";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "jceb";
    repo = program;
    rev = "v${version}";
    sha256 = "13dkjd1373mbvskrdrp0865llr3zvdr90sc6a6jqswh3crmgmz4k";
  };

  propagatedBuildInputs = [ python3 ];
  nativeBuildInputs = [ python3.pkgs.sphinx ];
  makeFlags = [ "PREFIX=$(out)" "VERSION=$(version)" ];

  meta = {
    description = "A program to generate and execute DesktopEntry files of the Application type";
    homepage = https://github.com/jceb/dex;
    platforms = stdenv.lib.platforms.linux;
  };
}

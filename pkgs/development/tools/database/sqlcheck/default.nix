{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "sqlcheck-${version}";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "jarulraj";
    repo = "sqlcheck";
    rev = "v${version}";
    sha256 = "0v8idyhwhbphxzmh03lih3wd9gdq317zn7wsf01infih7b6l0k69";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  doCheck = true;

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Automatically identify anti-patterns in SQL queries";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = [ maintainers.marsam ];
  };
}

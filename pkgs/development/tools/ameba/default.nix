{ stdenv, lib, fetchFromGitHub, crystal }:

crystal.buildCrystalPackage rec {
  pname = "ameba";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "crystal-ameba";
    repo = "ameba";
    rev = "v${version}";
    sha256 = "0myy11g62pa1yh9szj03v2lhc5s9xwzr76v4x6hznidpq1b67jn8";
  };

  meta = with stdenv.lib; {
    description = "A static code analysis tool for Crystal";
    homepage = "https://crystal-ameba.github.io";
    license = licenses.mit;
    maintainers = with maintainers; [ kimburgess ];
  };
}

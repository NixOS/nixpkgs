{ stdenv, lib, fetchFromGitHub, crystal }:

crystal.buildCrystalPackage rec {
  pname = "ameba";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "crystal-ameba";
    repo = "ameba";
    rev = "v${version}";
    sha256 = "0c2j2qki0czkpsqxv75qg95pk9f0w4rqa5ln07rs4bj9dk2lrr3l";
  };

  meta = with stdenv.lib; {
    description = "A static code analysis tool for Crystal";
    homepage = "https://crystal-ameba.github.io";
    license = licenses.mit;
    maintainers = with maintainers; [ kimburgess ];
  };
}

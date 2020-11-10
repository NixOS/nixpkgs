{ stdenv, lib, fetchFromGitHub, crystal }:

crystal.buildCrystalPackage rec {
  pname = "ameba";
  version = "0.13.2";

  src = fetchFromGitHub {
    owner = "crystal-ameba";
    repo = "ameba";
    rev = "v${version}";
    sha256 = "0wyfx9nwda0s3arpdalz5zgh83v6wfz1a3l2k5v0jglpczq3m04m";
  };

  meta = with stdenv.lib; {
    description = "A static code analysis tool for Crystal";
    homepage = "https://crystal-ameba.github.io";
    license = licenses.mit;
    maintainers = with maintainers; [ kimburgess ];
  };
}

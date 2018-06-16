{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonPackage rec {

  package = "lice";
  version = "0.4";
  name = "${package}-${version}";

  src = fetchFromGitHub {
    owner = "licenses";
    repo = "lice";
    rev = "71635c2544d5edf9e93af4141467763916a86624";
    sha256 = "059f9mnq7a5pxz2iiaih0nczq1v11m9zxr221agzv85qbwr7ii9f";
    fetchSubmodules = true;
  };

  meta = with stdenv.lib; {
    description = "";
    longDescription = ''

  '';
    homepage = https://github.com/licenses/lice;
    license = licenses.bsd3;
    maintainers = with maintainers; [ swflint ];
    platforms = platforms.unix;
  };

}

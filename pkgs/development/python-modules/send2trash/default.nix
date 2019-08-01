{ stdenv
, buildPythonPackage
, fetchFromGitHub
, pytest
}:

buildPythonPackage rec {
  pname = "Send2Trash";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "hsoft";
    repo = "send2trash";
    rev = version;
    sha256 = "1w502i5h8xaqf03g6h95h4vs1wqfv6kg925dn63phrwmg1hfz2xx";
  };

  doCheck = !stdenv.isDarwin;
  checkPhase = "HOME=$TMPDIR pytest";
  checkInputs = [ pytest ];

  meta = with stdenv.lib; {
    description = "Send file to trash natively under macOS, Windows and Linux";
    homepage = https://github.com/hsoft/send2trash;
    license = licenses.bsd3;
  };
}

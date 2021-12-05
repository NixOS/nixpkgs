{ lib, stdenv
, buildPythonPackage
, fetchFromGitHub
, pytest
}:

buildPythonPackage rec {
  pname = "Send2Trash";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "arsenetar";
    repo = "send2trash";
    rev = version;
    sha256 = "sha256-HZeN/kpisPRrVwg1xGGUjxspztZKRbacGY5gpa537cw=";
  };

  doCheck = !stdenv.isDarwin;
  checkPhase = "HOME=$TMPDIR pytest";
  checkInputs = [ pytest ];

  meta = with lib; {
    description = "Send file to trash natively under macOS, Windows and Linux";
    homepage = "https://github.com/arsenetar/send2trash";
    license = licenses.bsd3;
  };
}

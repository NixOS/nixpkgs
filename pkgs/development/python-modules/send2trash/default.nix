{ lib, stdenv
, buildPythonPackage
, fetchFromGitHub
, pytest
}:

buildPythonPackage rec {
  pname = "Send2Trash";
  version = "1.8.1b0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "hsoft";
    repo = "send2trash";
    rev = version;
    sha256 = "sha256-kDUEfyMTk8CXSxTEi7E6kl09ohnWHeaoif+EIaIJh9Q=";
  };

  doCheck = !stdenv.isDarwin;
  checkPhase = "HOME=$TMPDIR pytest";
  checkInputs = [ pytest ];

  meta = with lib; {
    description = "Send file to trash natively under macOS, Windows and Linux";
    homepage = "https://github.com/hsoft/send2trash";
    license = licenses.bsd3;
  };
}

{ lib, stdenv
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "Send2Trash";
  version = "1.8.1b0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "hsoft";
    repo = "send2trash";
    rev = "refs/tags/${version}";
    hash = "sha256-kDUEfyMTk8CXSxTEi7E6kl09ohnWHeaoif+EIaIJh9Q=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  doCheck = !stdenv.isDarwin;

  preCheck = ''
    export HOME=$TMPDIR
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Send file to trash natively under macOS, Windows and Linux";
    homepage = "https://github.com/hsoft/send2trash";
    license = licenses.bsd3;
  };
}

{ lib, stdenv
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "Send2Trash";
  version = "1.8.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "hsoft";
    repo = "send2trash";
    rev = "refs/tags/${version}";
    hash = "sha256-p0Pd9g+nLoT+oruthwjBn2E9rznvcx35VmzOAce2iTY=";
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
    changelog = "https://github.com/arsenetar/send2trash/blob/${version}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}

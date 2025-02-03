{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  mock,
  pytest-cov-stub,
  pytest-xdist,
  pytestCheckHook
}:

buildPythonPackage rec {
  pname = "uvcclient";
  version = "0.12.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kk7ds";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-ilZTRoSuoJMWlyRfvY/PpTBbr+d6wx+T3cVyW3ZkXlY=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [
    mock
    pytest-cov-stub
    pytest-xdist
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/uilibs/uvcclient/blob/${src.rev}/CHANGELOG.md";
    description = "Client for Ubiquiti's Unifi Camera NVR";
    mainProgram = "uvc";
    homepage = "https://github.com/kk7ds/uvcclient";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hexa ];
  };
}

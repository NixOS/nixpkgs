{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  mock,
  pytest-cov-stub,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "uvcclient";
  version = "0.12.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kk7ds";
    repo = "uvcclient";
    tag = "v${version}";
    hash = "sha256-V7xIvZ9vIXHPpkEeJZ6QedWk+4ZVNwCzj5ffLyixFz4=";
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

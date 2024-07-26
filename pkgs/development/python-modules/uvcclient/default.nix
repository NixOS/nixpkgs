{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  mock,
  pytestCheckHook
}:

buildPythonPackage rec {
  pname = "uvcclient";
  version = "0.11.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kk7ds";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-0OUdBygL2AAtccL5hdyL+0PIRK4o+lNN3droWDysDeI=";
  };

  postPatch = ''
    substituteInPlace tests/test_camera.py \
      --replace-fail "assertEquals" "assertEqual"
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Client for Ubiquiti's Unifi Camera NVR";
    mainProgram = "uvc";
    homepage = "https://github.com/kk7ds/uvcclient";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hexa ];
  };
}

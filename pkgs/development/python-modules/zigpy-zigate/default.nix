{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gpiozero,
  mock,
  pyserial,
  pyserial-asyncio,
  pyusb,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  zigpy,
}:

buildPythonPackage rec {
  pname = "zigpy-zigate";
  version = "0.13.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zigpy-zigate";
    rev = "refs/tags/${version}";
    hash = "sha256-MlAX7dcRZziMYCpG64OemZ8czwvDXpdoRaDVo1sUCno=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace ', "setuptools-git-versioning<2"' "" \
      --replace 'dynamic = ["version"]' 'version = "${version}"'
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    gpiozero
    pyserial
    pyserial-asyncio
    pyusb
    zigpy
  ];

  nativeCheckInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "zigpy_zigate" ];

  disabledTestPaths = [
    # Fails in sandbox
    "tests/test_application.py "
  ];

  meta = with lib; {
    description = "Library which communicates with ZiGate radios for zigpy";
    homepage = "https://github.com/zigpy/zigpy-zigate";
    changelog = "https://github.com/zigpy/zigpy-zigate/releases/tag/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mvnetbiz ];
    platforms = platforms.linux;
  };
}

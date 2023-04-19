{ lib
, async-timeout
, buildPythonPackage
, coloredlogs
, fetchFromGitHub
, jsonschema
, pytest-asyncio
, pytest-mock
, pytest-timeout
, pytest-xdist
, pytestCheckHook
, pythonOlder
, voluptuous
, zigpy
}:

buildPythonPackage rec {
  pname = "zigpy-znp";
  version = "0.10.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-pQ1T7MTrL789kd8cbbsjRLUaxd1yHF7sDwow2UksQ7c=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "timeout = 20" "timeout = 300"
  '';

  propagatedBuildInputs = [
    async-timeout
    coloredlogs
    jsonschema
    voluptuous
    zigpy
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytest-timeout
    pytest-xdist
    pytestCheckHook
  ];

  pytestFlagsArray = [
    # https://github.com/zigpy/zigpy-znp/issues/209
    "--deselect=tests/application/test_joining.py::test_join_device"
    "--deselect=tests/application/test_joining.py::test_permit_join"
    "--deselect=tests/application/test_requests.py::test_request_recovery_route_rediscovery_af"
    "--deselect=tests/application/test_requests.py::test_request_recovery_route_rediscovery_zdo"
    "--deselect=tests/application/test_requests.py::test_zigpy_request"
    "--deselect=tests/application/test_requests.py::test_zigpy_request_failure"
    "--deselect=tests/application/test_zdo_requests.py::test_mgmt_nwk_update_req"
  ];

  pythonImportsCheck = [
    "zigpy_znp"
  ];

  meta = with lib; {
    description = "Library for zigpy which communicates with TI ZNP radios";
    homepage = "https://github.com/zigpy/zigpy-znp";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mvnetbiz ];
    platforms = platforms.linux;
  };
}

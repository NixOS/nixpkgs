{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "smhi-pkg";
  version = "1.0.14";

  src = fetchFromGitHub {
    owner = "joysoftware";
    repo = "pypi_smhi";
    rev = version;
    sha256 = "186xwrg3hvr0hszq2kxvygd241q2sp11gfk6mwj9z4zqywwfcbn3";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # Disable tests that needs network access
    "test_smhi_integration_test"
    "test_smhi_async_integration_test"
    "test_smhi_async_integration_test_use_session"
    "test_smhi_async_get_forecast_integration2"
    "test_async_error_from_api"
  ];

  pythonImportsCheck = [ "smhi" ];

  meta = with lib; {
    description = "Python library for accessing SMHI open forecast data";
    homepage = "https://github.com/joysoftware/pypi_smhi";
    changelog = "https://github.com/joysoftware/pypi_smhi/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

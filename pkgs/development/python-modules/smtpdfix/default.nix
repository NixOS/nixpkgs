{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonAtLeast,
  setuptools,
  pytest,
  portpicker,
  cryptography,
  aiosmtpd,
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "smtpdfix";
  version = "0.5.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5NGs6Q83EqGRJ+2IdOaXqGFIwfSNKy2wwHIJaOjj7JU=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    aiosmtpd
    cryptography
    portpicker
    pytest
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.12") [
    # https://github.com/bebleo/smtpdfix/issues/335
    "test_missing_certs"
  ];

  meta = with lib; {
    description = "SMTP server for use as a pytest fixture for testing";
    homepage = "https://github.com/bebleo/smtpdfix";
    changelog = "https://github.com/bebleo/smtpdfix/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = teams.wdz.members;
  };
}

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
  version = "0.5.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LqSbIv4ITJy5KlLlboNRx1PJhe7PcTx38IUW7F4uf9A=";
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

  meta = {
    description = "SMTP server for use as a pytest fixture for testing";
    homepage = "https://github.com/bebleo/smtpdfix";
    changelog = "https://github.com/bebleo/smtpdfix/releases/tag/v${version}";
    license = lib.licenses.mit;
  };
}

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
<<<<<<< HEAD
  version = "0.5.3";
=======
  version = "0.5.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-LqSbIv4ITJy5KlLlboNRx1PJhe7PcTx38IUW7F4uf9A=";
=======
    hash = "sha256-5NGs6Q83EqGRJ+2IdOaXqGFIwfSNKy2wwHIJaOjj7JU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "SMTP server for use as a pytest fixture for testing";
    homepage = "https://github.com/bebleo/smtpdfix";
    changelog = "https://github.com/bebleo/smtpdfix/releases/tag/v${version}";
    license = lib.licenses.mit;
    teams = [ lib.teams.wdz ];
=======
  meta = with lib; {
    description = "SMTP server for use as a pytest fixture for testing";
    homepage = "https://github.com/bebleo/smtpdfix";
    changelog = "https://github.com/bebleo/smtpdfix/releases/tag/v${version}";
    license = licenses.mit;
    teams = [ teams.wdz ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

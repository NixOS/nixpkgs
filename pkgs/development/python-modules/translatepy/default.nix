{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  beautifulsoup4,
  pyuseragents,
  safeio,
  inquirer,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "translatepy";
  version = "2.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Animenosekai";
    repo = "translate";
    tag = "v${version}";
    hash = "sha256-cx5OeBrB8il8KrcyOmQbQ7VCXoaA5RP++oTTxCs/PcM=";
  };

  propagatedBuildInputs = [
    requests
    beautifulsoup4
    pyuseragents
    safeio
    inquirer
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  disabledTestPaths = [
    # Requires network connection
    "tests/test_translate.py"
    "tests/test_translators.py"
  ];
  pythonImportsCheck = [ "translatepy" ];

  meta = with lib; {
    description = "Module grouping multiple translation APIs";
    mainProgram = "translatepy";
    homepage = "https://github.com/Animenosekai/translate";
    license = with licenses; [ agpl3Only ];
    maintainers = with maintainers; [ emilytrau ];
  };
}

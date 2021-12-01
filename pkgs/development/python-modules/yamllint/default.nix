{ lib
, buildPythonPackage
, fetchPypi
, pathspec
, pytestCheckHook
, pythonOlder
, pyyaml
, stdenv
}:

buildPythonPackage rec {
  pname = "yamllint";
  version = "1.26.3";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3934dcde484374596d6b52d8db412929a169f6d9e52e20f9ade5bf3523d9b96e";
  };

  propagatedBuildInputs = [
    pyyaml
    pathspec
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # test failure reported upstream: https://github.com/adrienverge/yamllint/issues/373
    "test_find_files_recursively"
  ] ++ lib.optional stdenv.isDarwin [
    # locale tests are broken on BSDs; see https://github.com/adrienverge/yamllint/issues/307
    "test_locale_accents"
    "test_locale_case"
    "test_run_with_locale"
  ];

  pythonImportsCheck = [ "yamllint" ];

  meta = with lib; {
    description = "A linter for YAML files";
    homepage = "https://github.com/adrienverge/yamllint";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jonringer mikefaille ];
  };
}

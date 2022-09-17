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
  version = "1.27.1";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-5ogyS1hWCraKGjz/LApHTj/tNx3+jaXRuYF7ffVQOc4=";
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

{ lib
, buildPythonPackage
<<<<<<< HEAD
, fetchFromGitHub
, setuptools
=======
, fetchPypi
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pathspec
, pytestCheckHook
, pythonOlder
, pyyaml
, stdenv
}:

buildPythonPackage rec {
  pname = "yamllint";
<<<<<<< HEAD
  version = "1.32.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "adrienverge";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-DtIQ/gUBFQBm0OOJC2c/ONn2ZKsMAzdwMx7FbUo+uIU=";
  };

  nativeBuildInputs = [
    setuptools
  ];

=======
  version = "1.31.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LYPx0S9zPhYqh+BrF2FJ17ucW65Knl/OHHcdf3A/emU=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    pyyaml
    pathspec
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # test failure reported upstream: https://github.com/adrienverge/yamllint/issues/373
    "test_find_files_recursively"
  ] ++ lib.optionals stdenv.isDarwin [
    # locale tests are broken on BSDs; see https://github.com/adrienverge/yamllint/issues/307
    "test_locale_accents"
    "test_locale_case"
    "test_run_with_locale"
  ];

  pythonImportsCheck = [ "yamllint" ];

  meta = with lib; {
    description = "A linter for YAML files";
    homepage = "https://github.com/adrienverge/yamllint";
    changelog = "https://github.com/adrienverge/yamllint/blob/v${version}/CHANGELOG.rst";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jonringer mikefaille ];
  };
}

{ lib, fetchFromGitHub, python3 }:

with python3.pkgs;

buildPythonApplication rec {
  pname = "check-jsonschema";
<<<<<<< HEAD
  version = "0.23.3";
=======
  version = "0.21.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-jsonschema";
    repo = "check-jsonschema";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-gPFG1AgInakF8leMM0c1zZt2OdZdIKcUmItwICV8p1I=";
=======
    hash = "sha256-7cXnV27LCG1MXDH28UBmUC4sLooH2gKvGYF3YijLB38=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    ruamel-yaml
    jsonschema
    requests
    click
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
    responses
  ];

<<<<<<< HEAD
=======
  pytestFlagsArray = [
    # DeprecationWarning: Accessing jsonschema.draft3_format_checker is deprecated and will be removed in a future release. Instead, use the FORMAT_CHECKER attribute on the corresponding Validator.
    "-W" "ignore::DeprecationWarning"
  ];

  preCheck = lib.optionalString (stdenv.isDarwin && stdenv.isAarch64) ''
    # https://github.com/python/cpython/issues/74570#issuecomment-1093748531
    export no_proxy='*';
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [
    "check_jsonschema"
    "check_jsonschema.cli"
  ];

  meta = with lib; {
    description = "A jsonschema CLI and pre-commit hook";
    homepage = "https://github.com/python-jsonschema/check-jsonschema";
    changelog = "https://github.com/python-jsonschema/check-jsonschema/blob/${version}/CHANGELOG.rst";
<<<<<<< HEAD
    license = licenses.asl20;
=======
    license = licenses.apsl20;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ sudosubin ];
  };
}

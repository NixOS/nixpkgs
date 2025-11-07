{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  python-dateutil,
  tokenize-rt,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "time-machine";
  version = "2.19.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adamchainz";
    repo = "time-machine";
    tag = version;
    hash = "sha256-bPpn+RNlvy/tkFrxDY4Q13fNlNuMFj1+br8M2uU3t9A=";
  };

  build-system = [ setuptools ];

  dependencies = [
    python-dateutil
  ];

  optional-dependencies.cli = [
    tokenize-rt
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ optional-dependencies.cli;

  disabledTests = [
    # https://github.com/adamchainz/time-machine/issues/405
    "test_destination_string_naive"
    # Assertion Errors related to Africa/Addis_Ababa
    "test_destination_datetime_tzinfo_zoneinfo_nested"
    "test_destination_datetime_tzinfo_zoneinfo_no_orig_tz"
    "test_destination_datetime_tzinfo_zoneinfo"
    "test_move_to_datetime_with_tzinfo_zoneinfo"
  ];

  pythonImportsCheck = [ "time_machine" ];

  meta = with lib; {
    description = "Travel through time in your tests";
    homepage = "https://github.com/adamchainz/time-machine";
    changelog = "https://github.com/adamchainz/time-machine/blob/${src.rev}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}

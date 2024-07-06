{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "time-machine";
  version = "2.14.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "adamchainz";
    repo = "time-machine";
    rev = "refs/tags/${version}";
    hash = "sha256-NBqcVjZs2R5IWnwlEg26V3gBQVUDdM2ZIK7DMg372G4=";
  };

  build-system = [ setuptools ];

  dependencies = [ python-dateutil ];

  nativeCheckInputs = [ pytestCheckHook ];

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
    changelog = "https://github.com/adamchainz/time-machine/blob/${src.rev}/CHANGELOG.rst";
    homepage = "https://github.com/adamchainz/time-machine";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}

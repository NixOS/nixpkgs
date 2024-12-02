{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,
  pythonOlder,
  setuptools,
  python-dateutil,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "time-machine";
  version = "2.15.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "adamchainz";
    repo = "time-machine";
    rev = "refs/tags/${version}";
    hash = "sha256-0WYmkrMMeCkBYxy2qGovdxftzrYW9x/3tdeBcYC47Z0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    python-dateutil
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = lib.optionals (pythonAtLeast "3.9") [
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

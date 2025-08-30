{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  python-dateutil,
  setuptools,
  tokenize-rt,
}:

buildPythonPackage rec {
  pname = "time-machine";
  version = "2.17.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adamchainz";
    repo = "time-machine";
    tag = version;
    hash = "sha256-5W5uObx+ZZf2mYPE1aLSM1sedeYZcrk5LgujFxilaDw=";
  };

  build-system = [ setuptools ];

  dependencies = [ python-dateutil ];

  nativeCheckInputs = [
    pytestCheckHook
    tokenize-rt
  ];

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
    changelog = "https://github.com/adamchainz/time-machine/blob/${src.tag}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}

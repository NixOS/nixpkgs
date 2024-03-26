{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonAtLeast
, pythonOlder
, setuptools
, backports-zoneinfo
, python-dateutil
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "time-machine";
  version = "2.13.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "adamchainz";
    repo = pname;
    rev = version;
    hash = "sha256-SjenPLLr4JoWK5HAokwgW+bw3mfAZiuDb1N7Za5wtrw=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    python-dateutil
  ] ++ lib.optionals (pythonOlder "3.9") [
    backports-zoneinfo
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.9") [
    # https://github.com/adamchainz/time-machine/issues/405
    "test_destination_string_naive"
    # Assertion Errors related to Africa/Addis_Ababa
    "test_destination_datetime_tzinfo_zoneinfo_nested"
    "test_destination_datetime_tzinfo_zoneinfo_no_orig_tz"
    "test_destination_datetime_tzinfo_zoneinfo"
    "test_move_to_datetime_with_tzinfo_zoneinfo"
  ];

  pythonImportsCheck = [
    "time_machine"
  ];

  meta = with lib; {
    changelog = "https://github.com/adamchainz/time-machine/blob/${src.rev}/CHANGELOG.rst";
    description = "Travel through time in your tests";
    homepage = "https://github.com/adamchainz/time-machine";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}

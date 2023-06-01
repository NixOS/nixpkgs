{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonAtLeast
, pythonOlder
, backports-zoneinfo
, python-dateutil
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "time-machine";
  version = "2.9.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "adamchainz";
    repo = pname;
    rev = version;
    hash = "sha256-mE9unzVh0QXSl93hHH43o8AshDEzrl2NXsBJ2fph5is=";
  };

  propagatedBuildInputs = [
    python-dateutil
  ] ++ lib.optionals (pythonOlder "3.9") [
    backports-zoneinfo
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.9") [
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
    description = "Travel through time in your tests";
    homepage = "https://github.com/adamchainz/time-machine";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}

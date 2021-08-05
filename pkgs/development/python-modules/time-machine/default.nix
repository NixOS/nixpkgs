{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, python-dateutil
, pythonOlder
}:

buildPythonPackage rec {
  pname = "time-machine";
  version = "2.3.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "adamchainz";
    repo = pname;
    rev = version;
    sha256 = "1flim8xaa7qglh2b39cf57i8g0kg0707pw3mdkrgh0xjn27bv9bi";
  };

  propagatedBuildInputs = [
    python-dateutil
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Those tests have issues in the sandbox
    "test_destination_datetime_tzinfo_zoneinfo"
    "test_destination_datetime_tzinfo_zoneinfo_nested"
    "test_move_to_datetime_with_tzinfo_zoneinfo"
  ];

  pythonImportsCheck = [ "time_machine" ];

  meta = with lib; {
    description = "Python module to travel through time in tests";
    homepage = "https://github.com/adamchainz/time-machine";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

{ lib, python3Packages, fetchPypi, ... }:

python3Packages.buildPythonPackage rec {
  pname = "ical2orgpy";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-7/kWW1oTSJXPJtN02uIDrFdNJ9ExKRUa3tUNA0oJSoc=";
  };

  disabled = python3Packages.pythonOlder "3.9";

  propagatedBuildInputs = with python3Packages; [
    click
    future
    icalendar
    pytz
    tzlocal
    recurring-ical-events
  ];
  checkInputs = with python3Packages; [ freezegun pytest pyyaml ];
  nativeBuildInputs = [ python3Packages.pbr ];

  meta = with lib; {
    description = "Converting ICAL file into org-mode format.";
    homepage = "https://github.com/ical2org-py/ical2org.py";
    license = licenses.gpl3;
    maintainers = with maintainers; [ StillerHarpo ];
  };

}

{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ical2orgpy";
  version = "0.5";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ical2org-py";
    repo = "ical2org.py";
    rev = version;
    hash = "sha256-vBi1WYXMuDFS/PnwFQ/fqN5+gIvtylXidfZklyd6LcI=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    click
    future
    icalendar
    pytz
    tzlocal
    recurring-ical-events
  ];

  nativeCheckInputs = with python3.pkgs; [
    freezegun
    pytestCheckHook
    pyyaml
  ];

  meta = with lib; {
    changelog = "https://github.com/ical2org-py/ical2org.py/blob/${src.rev}/CHANGELOG.rst";
    description = "Converting ICAL file into org-mode format";
    homepage = "https://github.com/ical2org-py/ical2org.py";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ StillerHarpo ];
  };

}

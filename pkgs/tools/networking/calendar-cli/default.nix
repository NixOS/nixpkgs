{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "calendar-cli";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "tobixen";
    repo = "calendar-cli";
    rev = "v${version}";
    hash = "sha256-VVE4+qoUam2szbMsdWetq6hyhXoE1V3Pw5j/bYbfGVQ=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    icalendar
    caldav
    pytz
    tzlocal
    click
    six
  ];

  # tests require networking
  doCheck = false;

  meta = with lib; {
    description = "Simple command-line CalDav client";
    homepage = "https://github.com/tobixen/calendar-cli";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}

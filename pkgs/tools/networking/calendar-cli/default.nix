{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "calendar-cli";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "tobixen";
    repo = "calendar-cli";
    rev = "v${version}";
    hash = "sha256-wGigrBl5PJL+fVfnFnHDJ5zyB+Rq3Fm+q9vMvLuBBys=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    icalendar
    caldav
    pytz
    tzlocal
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

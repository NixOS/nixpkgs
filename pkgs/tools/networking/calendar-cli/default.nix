{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "calendar-cli";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "tobixen";
    repo = "calendar-cli";
    rev = "v${version}";
    sha256 = "0qjld2m7hl3dx90491pqbjcja82c1f5gwx274kss4lkb8aw0kmlv";
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

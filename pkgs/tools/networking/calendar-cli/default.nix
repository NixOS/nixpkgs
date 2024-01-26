{ lib
, python3
, fetchFromGitHub
, nixosTests
}:

python3.pkgs.buildPythonApplication rec {
  pname = "calendar-cli";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "tobixen";
    repo = "calendar-cli";
    rev = "v${version}";
    hash = "sha256-w35ySLnfxXZR/a7BrPLYqXs2kqkuYhh5PcgNxJqjDtE=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    icalendar
    caldav
    pytz
    pyyaml
    tzlocal
    click
    six
  ];

  # tests require networking
  doCheck = false;

  passthru.tests = {
    inherit (nixosTests) radicale;
  };

  meta = with lib; {
    description = "Simple command-line CalDav client";
    homepage = "https://github.com/tobixen/calendar-cli";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}

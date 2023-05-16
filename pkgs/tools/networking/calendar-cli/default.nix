{ lib
, python3
, fetchFromGitHub
<<<<<<< HEAD
, nixosTests
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

python3.pkgs.buildPythonApplication rec {
  pname = "calendar-cli";
<<<<<<< HEAD
  version = "1.0.1";
=======
  version = "0.14.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "tobixen";
    repo = "calendar-cli";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-w35ySLnfxXZR/a7BrPLYqXs2kqkuYhh5PcgNxJqjDtE=";
=======
    hash = "sha256-VVE4+qoUam2szbMsdWetq6hyhXoE1V3Pw5j/bYbfGVQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = with python3.pkgs; [
    icalendar
    caldav
    pytz
<<<<<<< HEAD
    pyyaml
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    tzlocal
    click
    six
  ];

  # tests require networking
  doCheck = false;

<<<<<<< HEAD
  passthru.tests = {
    inherit (nixosTests) radicale;
  };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Simple command-line CalDav client";
    homepage = "https://github.com/tobixen/calendar-cli";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}

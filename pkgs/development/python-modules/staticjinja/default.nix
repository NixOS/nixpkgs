{ lib
, fetchFromGitHub
, buildPythonPackage
, poetry-core
, docopt-ng
, easywatch
, jinja2
, pytestCheckHook
, pytest-check
, pythonOlder
, markdown
, testers
, tomlkit
<<<<<<< HEAD
, typing-extensions
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, staticjinja
, callPackage
}:

buildPythonPackage rec {
  pname = "staticjinja";
<<<<<<< HEAD
  version = "5.0.0";
=======
  version = "4.1.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.6";

  # No tests in pypi
  src = fetchFromGitHub {
    owner = "staticjinja";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-LfJTQhZtnTOm39EWF1m2MP5rxz/5reE0G1Uk9L7yx0w=";
=======
    hash = "sha256-w6ge5MQXNRHCM43jKnagTlbquJJys7mprgBOS2uuwHQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    jinja2
    docopt-ng
    easywatch
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-check
    markdown
    tomlkit
<<<<<<< HEAD
    typing-extensions
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  # The tests need to find and call the installed staticjinja executable
  preCheck = ''
    export PATH="$PATH:$out/bin";
  '';

  passthru.tests = {
    version = testers.testVersion { package = staticjinja; };
    minimal-template = callPackage ./test-minimal-template {};
  };

  meta = with lib; {
    description = "A library and cli tool that makes it easy to build static sites using Jinja2";
    homepage = "https://staticjinja.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
  };
}

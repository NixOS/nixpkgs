{ lib
, fetchFromGitHub
, python3Packages
, nixosTests
}:

python3Packages.buildPythonApplication rec {
  pname = "xandikos";
<<<<<<< HEAD
  version = "0.2.10";
  format = "pyproject";

  disabled = python3Packages.pythonOlder "3.9";
=======
  version = "0.2.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "jelmer";
    repo = "xandikos";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-SqU/K3b8OML3PvFmP7L5R3Ub9vbW66xRpf79mgFZPfc=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools
    wheel
  ];

  propagatedBuildInputs = with python3Packages; [
    aiohttp
    aiohttp-openmetrics
=======
    sha256 = "sha256-KDDk0QSOjwivJFz3vLk+g4vZMlSuX2FiOgHJfDJkpwg=";
  };

  propagatedBuildInputs = with python3Packages; [
    aiohttp
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    dulwich
    defusedxml
    icalendar
    jinja2
    multidict
<<<<<<< HEAD
    vobject
=======
    prometheus-client
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  passthru.tests.xandikos = nixosTests.xandikos;

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];
<<<<<<< HEAD
=======
  disabledTests = [
    # these tests are failing due to the following error:
    # TypeError: expected str, bytes or os.PathLike object, not int
    "test_iter_with_etag"
    "test_iter_with_etag_missing_uid"
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Lightweight CalDAV/CardDAV server";
    homepage = "https://github.com/jelmer/xandikos";
    license = licenses.gpl3Plus;
    changelog = "https://github.com/jelmer/xandikos/blob/v${version}/NEWS";
    maintainers = with maintainers; [ _0x4A6F ];
  };
}

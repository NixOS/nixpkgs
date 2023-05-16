{ lib
<<<<<<< HEAD
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "past-time";
  version = "0.2.1";
  format = "setuptools";
=======
, buildPythonApplication
, click
, fetchFromGitHub
, freezegun
, pytestCheckHook
, tqdm
}:

buildPythonApplication rec {
  pname = "past-time";
  version = "0.2.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "fabaff";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/${version}";
    hash = "sha256-9LmFOWNUkvKfWHLo4HB1W1UBQL90Gp9UJJ3VDIYBDHo=";
  };

  propagatedBuildInputs = with python3.pkgs; [
=======
    rev = version;
    sha256 = "0yhc0630rmcx4ia9y6klpx002mavfmqf1s3jb2gz54jlccwqbfgl";
  };

  propagatedBuildInputs = [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    click
    tqdm
  ];

<<<<<<< HEAD
  nativeCheckInputs = with python3.pkgs; [
=======
  nativeCheckInputs = [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    freezegun
    pytestCheckHook
  ];

<<<<<<< HEAD
  pythonImportsCheck = [
    "past_time"
  ];
=======
  pythonImportsCheck = [ "past_time" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Tool to visualize the progress of the year based on the past days";
    homepage = "https://github.com/fabaff/past-time";
<<<<<<< HEAD
    changelog = "https://github.com/fabaff/past-time/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}

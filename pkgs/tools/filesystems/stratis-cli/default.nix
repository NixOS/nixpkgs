{ lib
, python3Packages
, fetchFromGitHub
, nixosTests
}:

python3Packages.buildPythonApplication rec {
  pname = "stratis-cli";
<<<<<<< HEAD
  version = "3.5.3";
  format = "pyproject";
=======
  version = "3.5.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "stratis-storage";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-YoPi2AtP6qZPMrlxbDAD0sDEKrSBHLLRcHbNLxlXXCk=";
=======
    hash = "sha256-aDWHXKmlKKJo+ckW1vA0bm4q5z2g/Zx5frVDR6Kwgjw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = with python3Packages; [
    psutil
    python-dateutil
    wcwidth
    justbytes
    dbus-client-gen
    dbus-python-client-gen
    packaging
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # tests below require dbus daemon
    "tests/whitebox/integration"
<<<<<<< HEAD
=======
    "tests/whitebox/monkey_patching"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  pythonImportsCheck = [ "stratis_cli" ];

  passthru.tests = nixosTests.stratis;

  meta = with lib; {
    description = "CLI for the Stratis project";
    homepage = "https://stratis-storage.github.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
  };
}

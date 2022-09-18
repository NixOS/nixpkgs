{ lib
, python3Packages
, fetchFromGitHub
, nixosTests
}:

python3Packages.buildPythonApplication rec {
  pname = "stratis-cli";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "stratis-storage";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-JQXTzvm4l/pl2T4djZ3HEdDQJdFE+I9doe8Iv5q34kw=";
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

  checkInputs = with python3Packages; [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # tests below require dbus daemon
    "tests/whitebox/integration"
    "tests/whitebox/monkey_patching"
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

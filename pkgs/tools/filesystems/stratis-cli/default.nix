{ lib
, python3Packages
, fetchFromGitHub
, nixosTests
}:

python3Packages.buildPythonApplication rec {
  pname = "stratis-cli";
  version = "3.5.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "stratis-storage";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-qQufRG+7Z7xUCRg2/aIzG8FH1j4PFFThS2ljwrT285s=";
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

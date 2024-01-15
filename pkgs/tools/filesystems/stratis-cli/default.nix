{ lib
, python3Packages
, fetchFromGitHub
, nixosTests
}:

python3Packages.buildPythonApplication rec {
  pname = "stratis-cli";
  version = "3.6.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "stratis-storage";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-mLmjMofdr0U+Bfnkde7lJqPXkd1ICPYdlcsOm2nOcQA=";
  };

  propagatedBuildInputs = with python3Packages; [
    dbus-client-gen
    dbus-python-client-gen
    justbytes
    packaging
    psutil
    python-dateutil
    wcwidth
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # tests below require dbus daemon
    "tests/whitebox/integration"
  ];

  pythonImportsCheck = [ "stratis_cli" ];

  passthru.tests = nixosTests.stratis;

  meta = with lib; {
    description = "CLI for the Stratis project";
    homepage = "https://stratis-storage.github.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
    mainProgram = "stratis";
  };
}

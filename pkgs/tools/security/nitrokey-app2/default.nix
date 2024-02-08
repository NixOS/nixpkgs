{ lib
, buildPythonApplication
, fetchFromGitHub
, pythonOlder
, pyside6
, poetry-core
, pynitrokey
, pyudev
, qt-material
}:

buildPythonApplication rec {
  pname = "nitrokey-app2";
  version = "2.2.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Nitrokey";
    repo = "nitrokey-app2";
    rev = "refs/tags/v${version}";
    hash = "sha256-v6isbZAdhFyQ3+SL37cWNUgIXT7dW7y6F21k6DZh60E=";
  };

  # https://github.com/Nitrokey/nitrokey-app2/issues/152
  #
  # pythonRelaxDepsHook does not work here, because it runs in postBuild and
  # only modifies the dependencies in the built distribution.
  postPatch = ''
    substituteInPlace pyproject.toml --replace 'pynitrokey = "' 'pynitrokey = ">='
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    pynitrokey
    pyudev
    pyside6
    qt-material
  ];

  pythonImportsCheck = [
    "nitrokeyapp"
  ];

  meta = with lib; {
    description = "This application allows to manage Nitrokey 3 devices";
    homepage = "https://github.com/Nitrokey/nitrokey-app2";
    changelog = "https://github.com/Nitrokey/nitrokey-app2/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ _999eagle panicgh ];
    mainProgram = "nitrokeyapp";
  };
}

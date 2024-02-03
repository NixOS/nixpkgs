{ lib
, python3
, fetchFromGitHub
, pynitrokey
, wrapQtAppsHook
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nitrokey-app2";
  version = "2.1.2";
  pyproject = true;

  disabled = python3.pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Nitrokey";
    repo = "nitrokey-app2";
    rev = "v${version}";
    hash = "sha256-VyhIFNXxH/FohgjhBeZXoQYppP7PEz+ei0qzsWz1xhk=";
  };

  # https://github.com/Nitrokey/nitrokey-app2/issues/152
  #
  # pythonRelaxDepsHook does not work here, because it runs in postBuild and
  # only modifies the dependencies in the built distribution.
  postPatch = ''
    substituteInPlace pyproject.toml --replace "pynitrokey ==" "pynitrokey >="
  '';

  # The pyproject.toml file seems to be incomplete and does not generate
  # resources (i.e. run pyrcc5 and pyuic5) but the Makefile does.
  preBuild = ''
    make build-ui
  '';

  nativeBuildInputs = with python3.pkgs; [
    flit-core
    pyqt5
    wrapQtAppsHook
  ];

  dontWrapQtApps = true;

  propagatedBuildInputs = with python3.pkgs; [
    pynitrokey
    pyudev
    pyqt5
    pyqt5-stubs
    qt-material
  ];

  preFixup = ''
    wrapQtApp "$out/bin/nitrokeyapp" \
      --set-default CRYPTOGRAPHY_OPENSSL_NO_LEGACY 1
  '';

  pythonImportsCheck = [
    "nitrokeyapp"
  ];

  meta = with lib; {
    description = "This application allows to manage Nitrokey 3 devices";
    homepage = "https://github.com/Nitrokey/nitrokey-app2";
    changelog = "https://github.com/Nitrokey/nitrokey-app2/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ _999eagle ];
    mainProgram = "nitrokeyapp";
  };
}

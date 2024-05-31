{ lib
, stdenv
, python3
, fetchFromGitHub
, wrapQtAppsHook
, qtbase
, qtwayland
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nitrokey-app2";
  version = "2.3.0";
  pyproject = true;

  disabled = python3.pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Nitrokey";
    repo = "nitrokey-app2";
    rev = "v${version}";
    hash = "sha256-BSq3ezNt6btQUO1hMVw9bN3VCyUOUhfRFJcHDGkIm6Q=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
    wrapQtAppsHook
  ];

  buildInputs = [ qtbase ] ++ lib.optionals stdenv.isLinux [
    qtwayland
  ];

  propagatedBuildInputs = with python3.pkgs; [
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

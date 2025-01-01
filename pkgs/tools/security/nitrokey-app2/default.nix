{ lib
, stdenv
, python3
, fetchFromGitHub
, wrapQtAppsHook
, qtbase
, qtwayland
, qtsvg
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nitrokey-app2";
  version = "2.3.2";
  pyproject = true;

  disabled = python3.pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Nitrokey";
    repo = "nitrokey-app2";
    rev = "refs/tags/v${version}";
    hash = "sha256-ekVf9ZuLqx7SuiD21iV5c60r7E8kk4jKoYM/T02ETrI=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
    wrapQtAppsHook
  ];

  buildInputs = [ qtbase ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    qtwayland qtsvg
  ];

  propagatedBuildInputs = with python3.pkgs; [
    nitrokey
    pyside6
    qt-material
    usb-monitor
  ];

  pythonRelaxDeps = [ "pynitrokey" ];

  pythonImportsCheck = [
    "nitrokeyapp"
  ];

  postInstall = ''
    install -Dm755 meta/com.nitrokey.nitrokey-app2.desktop $out/share/applications/com.nitrokey.nitrokey-app2.desktop
    install -Dm755 meta/nk-app2.png $out/share/icons/hicolor/128x128/apps/com.nitrokey.nitrokey-app2.png
  '';

  meta = with lib; {
    description = "This application allows to manage Nitrokey 3 devices";
    homepage = "https://github.com/Nitrokey/nitrokey-app2";
    changelog = "https://github.com/Nitrokey/nitrokey-app2/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ _999eagle panicgh ];
    mainProgram = "nitrokeyapp";
  };
}

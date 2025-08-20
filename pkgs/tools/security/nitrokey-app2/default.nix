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
  version = "2.3.3";
  pyproject = true;

  disabled = python3.pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Nitrokey";
    repo = "nitrokey-app2";
    tag = "v${version}";
    hash = "sha256-BbgP4V0cIctY/oR4/1r1MprkIn+5oyHeFiOQQQ71mNU=";
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

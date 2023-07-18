{ lib
, python3
, fetchFromGitHub
, pynitrokey
, wrapQtAppsHook
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nitrokey-app2";
  version = "2.1.2";
  format = "flit";

  src = fetchFromGitHub {
    owner = "Nitrokey";
    repo = "nitrokey-app2";
    rev = "v${version}";
    hash = "sha256-VyhIFNXxH/FohgjhBeZXoQYppP7PEz+ei0qzsWz1xhk=";
  };

  preBuild = ''
    make build-ui
  '';

  nativeBuildInputs = with python3.pkgs; [
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

  meta = with lib; {
    description = "This application allows to manage Nitrokey 3 devices";
    homepage = "https://github.com/Nitrokey/nitrokey-app2";
    license = licenses.asl20;
    maintainers = with maintainers; [ _999eagle ];
    mainProgram = "nitrokeyapp";
  };
}

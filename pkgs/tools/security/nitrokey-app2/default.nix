{
  lib,
  stdenv,
  buildPythonApplication,
  fetchFromGitHub,
  poetry-core,
  fido2,
  nitrokey,
  pyside6,
  usb-monitor,
  qt6,
}:

let
  inherit (qt6)
    wrapQtAppsHook
    qtbase
    qtwayland
    qtsvg
    ;
in

buildPythonApplication rec {
  pname = "nitrokey-app2";
<<<<<<< HEAD
  version = "2.4.3";
=======
  version = "2.4.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Nitrokey";
    repo = "nitrokey-app2";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-mwcYjkyEP2itwdQ/xAG50uvw6zHfUacAecbDh86GNGA=";
=======
    hash = "sha256-nzhhtnKKOHA+Cw1y+BpYsyQklzkDnmFRKGIfaJ/dmaQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    qtwayland
    qtsvg
  ];

  build-system = [
    poetry-core
  ];

  dependencies = [
    fido2
    nitrokey
    pyside6
    usb-monitor
  ];

  pythonRelaxDeps = [ "nitrokey" ];

  pythonImportsCheck = [
    "nitrokeyapp"
  ];

  postInstall = ''
    install -Dm755 meta/com.nitrokey.nitrokey-app2.desktop $out/share/applications/com.nitrokey.nitrokey-app2.desktop
    install -Dm755 meta/nk-app2.png $out/share/icons/hicolor/128x128/apps/com.nitrokey.nitrokey-app2.png
  '';

  # wrapQtApps only wrapps binary files and normally skips python programs.
  # Manually pass the qtWrapperArgs from wrapQtAppsHook to wrap python programs.
  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

<<<<<<< HEAD
  meta = {
    description = "This application allows to manage Nitrokey 3 devices";
    homepage = "https://github.com/Nitrokey/nitrokey-app2";
    changelog = "https://github.com/Nitrokey/nitrokey-app2/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "This application allows to manage Nitrokey 3 devices";
    homepage = "https://github.com/Nitrokey/nitrokey-app2";
    changelog = "https://github.com/Nitrokey/nitrokey-app2/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      _999eagle
      panicgh
    ];
    mainProgram = "nitrokeyapp";
  };
}

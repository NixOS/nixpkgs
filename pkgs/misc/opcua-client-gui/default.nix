{ lib
, stdenv
, python3Packages
, fetchFromGitHub
, makeDesktopItem
, copyDesktopItems
, desktopToDarwinBundle
, wrapQtAppsHook
}:

python3Packages.buildPythonApplication rec {
  pname = "opcua-client-gui";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "FreeOpcUa";
    repo = "opcua-client-gui";
    rev = version;
    hash = "sha256-0BH1Txr3z4a7iFcsfnovmBUreXMvIX2zpZa8QivQVx8=";
  };

  nativeBuildInputs = [ copyDesktopItems wrapQtAppsHook ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ desktopToDarwinBundle ];

  makeWrapperArgs = [
    "\${qtWrapperArgs[@]}"
  ];

  propagatedBuildInputs = with python3Packages; [
    pyqt5
    asyncua
    opcua-widgets
    numpy
    pyqtgraph
  ];

  #This test uses a deprecated libarby, when updating the package check if the test was updated as well
  doCheck = false;

  desktopItems = [
    (makeDesktopItem {
      name = "opcua-client";
      exec = "opcua-client";
      comment = "OPC UA Client";
      type = "Application";
      #no icon because the app dosn't have one
      desktopName = "opcua-client";
      terminal = false;
      categories = [ "Utility" ];
    })
  ];

  meta = with lib; {
    description = "OPC UA GUI Client";
    homepage = "https://github.com/FreeOpcUa/opcua-client-gui";
    platforms = platforms.unix;
    license = licenses.gpl3Only;
    maintainers = [ ];
    mainProgram = "opcua-client";
  };
}

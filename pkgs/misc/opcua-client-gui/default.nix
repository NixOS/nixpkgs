{ lib
, python3
, fetchFromGitHub
, makeDesktopItem
, copyDesktopItems
}:

python3.pkgs.buildPythonApplication rec {
  pname = "opcua-client-gui";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "FreeOpcUa";
    repo = pname;
    rev = version;
    hash = "sha256-0BH1Txr3z4a7iFcsfnovmBUreXMvIX2zpZa8QivQVx8=";
  };

  propagatedBuildInputs = with python3.pkgs; [
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
    platforms = platforms.linux;
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ janik ];
  };
}

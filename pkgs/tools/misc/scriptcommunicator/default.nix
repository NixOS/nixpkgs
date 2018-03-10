{ stdenv
, fetchFromGitHub, qmake, pkgconfig
, libpng, zlib, unzip
, qtbase, qttools, qtserialport, qtscript, qtmultimedia
, makeWrapper, makeDesktopItem
}:

let
  pname = "scriptcommunicator";
  version = "05.10";

  desktopItem = makeDesktopItem {
    name = "ScriptCommunicator";
    exec = "${pname}";
    icon = "$out/share/scriptcommunicator/images/main_32x32.png";
    comment = "Scriptable data terminal"; 
    desktopName = "ScriptCommunicator";
    genericName = "Data Terminal";
    categories = "Network;";
  };

in stdenv.mkDerivation rec {

  inherit pname version;

  nativeBuildInputs = [ unzip qmake makeWrapper ];
  buildInputs = [  qtserialport qtscript qtmultimedia ];

  # we want QtDesigner available to create UI
  propagatedBuildInputs = [ qttools ]; 

  src = fetchFromGitHub {
    owner = "szieke";
    repo = "ScriptCommunicator_serial-terminal";
    rev = "Release_${stdenv.lib.replaceStrings ["."] ["_"] version}";
    sha256 = "0v6lh5di5pxkqklp3iyvdqmr7w66c7xdd1r8lkk43sh7w7jnbvc9";
  };

  sourceRoot = "source/ScriptCommunicator";

  buildPhase = ''
    cd DeleteFolder/DeleteFolder
    qmake DeleteFolder.pro
    make
    cd ../..
    
    cd ScriptEditor
    qmake ScriptEditor.pro
    make
    cd ..

    qmake ScriptCommunicator.pro
    make
  '';

  installPhase = ''
    mkdir -p $out/{bin,share/scriptcommunicator,lib}

    cp -a ScriptEditor/apiFiles exampleScripts images templates test $out/share/scriptcommunicator
    cp ScriptEditor/ScriptEditor $out/share/scriptcommunicator/
    cp DeleteFolder/DeleteFolder/DeleteFolder $out/share/scriptcommunicator/
    cp ScriptCommunicator $out/share/scriptcommunicator/
    cp documentation/Manual_ScriptCommunicator.pdf $out/share/scriptcommunicator/
      
    makeWrapper $out/share/scriptcommunicator/ScriptCommunicator $out/bin/scriptcommunicator \
      --suffix PATH ':' "$out/share/scriptcommunicator"

    # Install desktop file
    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications/
  '';

  meta = with stdenv.lib; {
    description = "Scriptable data terminal which supports several interfaces";
    longDescription = ''
      In addition to the simple sending and receiving of data ScriptCommunicator
      has a QtScript (similar to JavaScript) interface.
      This script interface has following features:
      - Scripts can send and receive data with the main interface.
      - In addition to the main interface scripts can create and use own interfaces
      (serial port (RS232, USB to serial), UDP, TCP client, TCP server, PCAN and SPI/I2C).
      - Scripts can use their own GUI (GUI files which have been created with QtDesigner
        (is included) or QtCreator).
      - Multiple plot windows can be created by scripts (QCustomPlot from Emanuel Eichhammer is used)
    '';
    homepage = https://scriptcommunicator.sourceforge.io;
    license = licenses.lgpl3;
    maintainers = [ maintainers.genesis ];
    platforms = platforms.linux;
  };
}

{ lib, stdenv, fetchFromGitHub, fetchurl, cmake, pkg-config, extra-cmake-modules
, qt6, zlib, sqlite, kdePackages, callPackage }:

let
  kdsingleapplication = callPackage ./kdsingleapplication.nix { };

  libre-graph-api = stdenv.mkDerivation rec {
    pname = "libre-graph-api-cpp-qt-client";
    version = "1.0.4";

    src = fetchFromGitHub {
      owner = "owncloud";
      repo = "libre-graph-api-cpp-qt-client";
      rev = "v${version}";
      sha256 = "wbdamPi2XSLWeprrYZtBUDH1A2gdp6/5geFZv+ZqSWk=";
    };

    preConfigure = "cd client";

    nativeBuildInputs = [ cmake pkg-config qt6.wrapQtAppsHook ];

    buildInputs = [ qt6.qtbase qt6.qttools ];

    meta = with lib; {
      description = "C++ Qt client library for Libre Graph API";
      homepage = "https://github.com/owncloud/libre-graph-api-cpp-qt-client";
      license = licenses.asl20;
      platforms = platforms.linux;
    };
  };
in stdenv.mkDerivation rec {
  pname = "stack-client";
  version = "latest";

  src = fetchurl {
    url =
      "https://filehosting-client.transip.nl/packages/stack-source-latest.tar.gz";
    sha256 = "ac69699edb1618ef094e4b642fe72c87bf15e65026029486bef50826a746e19c";
  };

  nativeBuildInputs =
    [ cmake extra-cmake-modules qt6.qttools qt6.wrapQtAppsHook ];

  buildInputs =
    [ qt6.qtbase kdePackages.qtkeychain zlib sqlite libre-graph-api ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_PREFIX_PATH=${kdsingleapplication}"
  ];

  qtWrapperArgs = [
    "--prefix QT_PLUGIN_PATH : ${qt6.qtbase}/${qt6.qtbase.qtPluginPrefix}"
    "--prefix QML2_IMPORT_PATH : ${qt6.qtbase}/${qt6.qtbase.qtQmlPrefix}"
  ];

  meta = with lib; {
    description = "Stack Client Application - A secure cloud storage solution";
    longDescription = ''
      Stack Client is a desktop application that provides secure cloud storage and file 
      synchronization services by TransIP. It offers a robust set of features for both 
      personal and business users:

      Features:
      * Secure file synchronization across devices
      * Seamless desktop integration
      * File sharing capabilities with granular permissions
      * Automatic background synchronization
      * Version control and file history
      * Built-in security features
      * Cross-platform support
    '';
    homepage = "https://www.transip.nl/stack/";
    changelog = "https://www.transip.nl/stack/changelog/";
    license = licenses.unfree;
    maintainers = with maintainers; [ timoteuszelle ];
    platforms = platforms.linux;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}

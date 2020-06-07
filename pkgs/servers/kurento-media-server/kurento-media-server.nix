{ stdenv, makeWrapper, kurentoPackages, cmake, pkgconfig, boost
, glib, glibmm, libsigcxx, libevent, openssl, websocketpp }:
stdenv.mkDerivation {
  pname = "kurento-media-server";
  inherit (kurentoPackages.lib) version;

  src = kurentoPackages.lib.fetchKurento {
    repo = "kurento-media-server";
    sha256 = "13ic5nwrwqhb4i9yy2jr551jsbf179zs07gbqxl3wwc5hhr3gm6j";
  };

  postPatch = ''
    # Fix gstreamer version
    substituteInPlace CMakeLists.txt --replace 1.5 1.0

    # Add websocketpp
    echo 'find_package(WEBSOCKETPP REQUIRED)' >> server/transport/websocket/CMakeLists.txt

    # Remove built-in websocketpp (not compatible with newer OpenSSL, see bad73ecb26cf4b9791af17209fb2c54d5d25b4d9)
    rm -r server/transport/websocket/websocketpp
  '';

  buildInputs = with kurentoPackages; [ boost gst_all_1.gstreamer gst_all_1.gst-plugins-base kms-core kms-jsonrpc kmsjsoncpp libsigcxx glibmm libevent openssl websocketpp ];
  nativeBuildInputs = [ cmake pkgconfig makeWrapper ];
  cmakeFlagsArray = with kurentoPackages; lib.mkCmakeModules [ kms-cmake-utils kms-core kms-jsonrpc websocketpp ];

  meta = with stdenv.lib; {
    description = "Media Server responsible for media transmission, processing, loading and recording";
    homepage = "https://www.kurento.org";
    license = with licenses; [ asl20 ];
  };
}

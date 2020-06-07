{ stdenv, fetchFromGitHub, kurentoPackages, cmake, glib, glibmm, pkgconfig, boost, libsoup, libnice, libuuid, openssl, }:
stdenv.mkDerivation rec {
  pname = "kms-elements";
  inherit (kurentoPackages.lib) version;

  src = kurentoPackages.lib.fetchKurento {
    repo = "kms-elements";
    sha256 = "sha256-4U3RsBIdngu4D66PHWp5kY+QlRI22eSXlh41hqMEx5Q=";
  };

  # Copy files to the expected locations or the build will fail
  postUnpack = ''
    mkdir -p $out/share/java
    ln -s ${kurentoPackages.kurento-module-creator}/share/java/kurento-module-creator-jar-with-dependencies.jar $out/share/java/

    mkdir -p /build/modules
    ln -s ${kurentoPackages.kms-core}/share/kurento/modules/* /build/modules
  '';

  postPatch = ''
    # Fix gstreamer version
    substituteInPlace CMakeLists.txt --replace 1.5 1.0

    # Add the correct glib and gstreamer include directories
    for dir in server/implementation/HttpServer gst-plugins/{,recorderendpoint,rtcpdemux,rtpendpoint,webrtcendpoint}; do
      echo 'include_directories("${glib.dev}/include/glib-2.0" "${glib.out}/lib/glib-2.0/include")' >> "src/$dir/CMakeLists.txt"
      echo 'include_directories("${kurentoPackages.gst_all_1.gstreamer.dev}/include/gstreamer-1.0", "${kurentoPackages.gst_all_1.gst-plugins-base.dev}/include/gstreamer-1.0", "${kurentoPackages.gst_all_1.gst-plugins-bad.dev}/include/gstreamer-1.0")' >> "src/$dir/CMakeLists.txt"
    done
  '';

  buildInputs = with kurentoPackages; [ glibmm libsoup libnice libuuid openssl gst_all_1.gstreamer gst_all_1.gst-plugins-base gst_all_1.gst-plugins-bad kms-jsonrpc kmsjsoncpp kms-core ];
  nativeBuildInputs = [ cmake pkgconfig boost kurentoPackages.kurento-module-creator ];
  cmakeFlagsArray = with kurentoPackages; lib.mkCmakeModules [ kms-cmake-utils kms-core kurento-module-creator kms-jsonrpc kmsjsoncpp ];

  postFixup = ''
    # Add gst to dependencies
    for file in $(find $out/lib -name '*.so'); do
      patchelf --set-rpath "$(patchelf --print-rpath "$file"):${kurentoPackages.gst_all_1.gst-plugins-base.out}/lib:${kurentoPackages.gst_all_1.gst-plugins-bad.out}/lib" "$file"
      patchelf --add-needed libgstapp-1.0.so --add-needed libgstsctp-1.0.so --add-needed libgstrtp-1.0.so "$file"
    done

    # Fix filenames so gst can find the plugin metadata
    for name in recorderendpoint rtpendpoint webrtcendpoint; do
      mv $out/lib/gstreamer-1.0/lib''${name}.so $out/lib/gstreamer-1.0/libkms''${name}.so
    done
    mv $out/lib/gstreamer-1.0/libkmselementsplugins.so $out/lib/gstreamer-1.0/libkmselements.so
  '';

  meta = with stdenv.lib; {
    description = "Media elements for Kurento Media Server";
    homepage = "https://www.kurento.org";
    license = with licenses; [ asl20 ];
  };
}

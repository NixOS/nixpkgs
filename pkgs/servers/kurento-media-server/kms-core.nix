{ stdenv, kurentoPackages, cmake, pkgconfig, boost, glib, glibmm
, libsigcxx, libuuid, libvpx }:
stdenv.mkDerivation {
  pname = "kms-core";
  inherit (kurentoPackages.lib) version;

  src = kurentoPackages.lib.fetchKurento {
    repo = "kms-core";
    sha256 = "1aamz7ijjivggk4qq50gq7w71p25fzrsfyspwnxb2w4mgbvih9dm";
  };

  # Copy the jar to the expected location or the build will fail
  postUnpack = ''
    mkdir -p $out/share/java
    ln -s ${kurentoPackages.kurento-module-creator}/share/java/kurento-module-creator-jar-with-dependencies.jar $out/share/java/
  '';

  postPatch = ''
    # Fix gstreamer version
    substituteInPlace CMakeLists.txt --replace 1.5 1.0
    substituteInPlace src/gst-plugins/CMakeLists.txt --replace 1.5 1.0
    substituteInPlace src/gst-plugins/commons/CMakeLists.txt --replace 1.5 1.0
    substituteInPlace src/server/CMakeLists.txt --replace 1.5 1.0

    # Add the correct glib and gstreamer include directories
    for f in gst-plugins/vp8parse gst-plugins/commons/sdpagent; do
      echo 'include_directories("${glib.dev}/include/glib-2.0" "${glib.out}/lib/glib-2.0/include")' >> "src/$f/CMakeLists.txt"
      echo 'include_directories("${kurentoPackages.gst_all_1.gstreamer.dev}/include/gstreamer-1.0" "${kurentoPackages.gst_all_1.gst-plugins-base.dev}/include/gstreamer-1.0")' >> "src/$f/CMakeLists.txt"
    done

    # Fix building modules
    substituteInPlace CMake/CodeGenerator.cmake --replace /usr/share/kurento/modules /build/modules
  '';

  buildInputs = with kurentoPackages; [ boost kurento-module-creator gst_all_1.gstreamer gst_all_1.gst-plugins-base kms-jsonrpc kmsjsoncpp libsigcxx glibmm libuuid libvpx ];
  nativeBuildInputs = [ cmake pkgconfig ];
  cmakeFlagsArray = with kurentoPackages; lib.mkCmakeModules [ kms-cmake-utils kurento-module-creator kms-jsonrpc kmsjsoncpp ];

  # To find plugins missing their dependencies, run:
  # $ nix-shell -p kurentoPackages.kms-core -p gst_all_1.gstreamer
  # $ GST_REGISTRY= GST_PLUGIN_PATH=$(echo "$buildInputs" | cut -d' ' -f1)/lib/gstreamer-1.0 gst-inspect-1.0 -b
  postFixup = ''
    # Add gst to dependencies
    for file in $(find $out/lib -name '*.so'); do
      patchelf --set-rpath "$(patchelf --print-rpath "$file"):${kurentoPackages.gst_all_1.gstreamer.out}/lib:${kurentoPackages.gst_all_1.gst-plugins-base}/lib" "$file"
      patchelf --add-needed libgstbase-1.0.so --add-needed libgstvideo-1.0.so "$file"
    done

    mv $out/lib/gstreamer-1.0/libkmscoreplugins.so $out/lib/gstreamer-1.0/libkmscore.so
  '';

  meta = with stdenv.lib; {
    description = "Core library of Kurento Media Server";
    homepage = "https://www.kurento.org";
    license = with licenses; [ asl20 ];
  };
}

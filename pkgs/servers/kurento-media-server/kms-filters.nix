{ stdenv, fetchFromGitHub, kurentoPackages, cmake, pkgconfig, boost, glib, glibmm, libsigcxx, libsoup, opencv }:
stdenv.mkDerivation rec {
  pname = "kms-filters";
  inherit (kurentoPackages.lib) version;

  src = kurentoPackages.lib.fetchKurento {
    repo = "kms-filters";
    sha256 = "sha256-In6LXnOE4YqBJDTBkTntlmngWkmJrQ0lvtDpHgDPUiY=";
  };

  # Copy files to the expected locations or the build will fail
  postUnpack = ''
    mkdir -p $out/share/java
    ln -s ${kurentoPackages.kurento-module-creator}/share/java/kurento-module-creator-jar-with-dependencies.jar $out/share/java/

    mkdir -p /build/modules
    ln -s ${kurentoPackages.kms-core}/share/kurento/modules/* /build/modules
    ln -s ${kurentoPackages.kms-elements}/share/kurento/modules/* /build/modules
  '';

  postPatch = ''
    # Fix gstreamer version
    substituteInPlace CMakeLists.txt --replace 1.5 1.0

    # Add the correct glib and gstreamer include directories
    for dir in gst-plugins/{facedetector,faceoverlay,imageoverlay,logooverlay,movementdetector}; do
      echo 'include_directories("${glib.dev}/include/glib-2.0" "${glib.out}/lib/glib-2.0/include")' >> "src/$dir/CMakeLists.txt"
      echo 'include_directories("${kurentoPackages.gst_all_1.gstreamer.dev}/include/gstreamer-1.0", "${kurentoPackages.gst_all_1.gst-plugins-base.dev}/include/gstreamer-1.0")' >> "src/$dir/CMakeLists.txt"
    done
  '';

  buildInputs = with kurentoPackages; [ boost glibmm libsigcxx gst_all_1.gstreamer gst_all_1.gst-plugins-base libsoup opencv kms-core kms-jsonrpc kmsjsoncpp kms-elements ];
  nativeBuildInputs = [ cmake pkgconfig kurentoPackages.kurento-module-creator ];
  cmakeFlagsArray = with kurentoPackages; kurentoPackages.lib.mkCmakeModules [ kms-cmake-utils kms-core kurento-module-creator kms-core kms-jsonrpc kmsjsoncpp kms-elements ];

  postFixup = ''
    # Add gst to dependencies
    for file in $(find $out/lib -name '*.so'); do
      patchelf --set-rpath "$(patchelf --print-rpath "$file"):${kurentoPackages.gst_all_1.gst-plugins-base}/lib" "$file"
      patchelf --add-needed libgstvideo-1.0.so "$file"
    done

    # Fix filenames so gst can find the plugin metadata
    for name in logooverlay opencvfilter movementdetector imageoverlay faceoverlay facedetector; do
      mv $out/lib/gstreamer-1.0/lib''${name}.so $out/lib/gstreamer-1.0/libkms''${name}.so
    done
  '';

  meta = with stdenv.lib; {
    description = "Filter elements for Kurento Media Server";
    homepage = "https://www.kurento.org";
    license = with licenses; [ asl20 ];
  };
}

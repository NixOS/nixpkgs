{ stdenv, fetchhg, cmake, dos2unix, glib, gst_all_1, makeWrapper, pkgconfig
, python, SDL2, SDL2_image, SDL2_mixer, SDL2_ttf, sqlite, zlib
}:

stdenv.mkDerivation rec {
  name = "retrofe-${version}";
  version = "0.6.169";

  src = fetchhg {
    url = https://bitbucket.org/teamretro/retrofe;
    rev = "8793e03";
    sha256 = "0cvsg07ff0fdqh5zgiv2fs7s6c98hn150kpxmpw5fn6jilaszwkm";
  };

  nativeBuildInputs = [ cmake makeWrapper pkgconfig python ];

  buildInputs = [
    glib gst_all_1.gstreamer SDL2 SDL2_image SDL2_mixer SDL2_ttf sqlite zlib
  ] ++ (with gst_all_1; [ gst-libav gst-plugins-base gst-plugins-good ]);

  patches = [ ./include-paths.patch ];

  configurePhase = ''
    cmake RetroFE/Source -BRetroFE/Build -DCMAKE_BUILD_TYPE=Release \
      -DVERSION_MAJOR=0 -DVERSION_MINOR=0 -DVERSION_BUILD=0 \
      -DGSTREAMER_BASE_INCLUDE_DIRS='${gst_all_1.gst-plugins-base.dev}/include/gstreamer-1.0'
  '';

  buildPhase = ''
    cmake --build RetroFE/Build
    python Scripts/Package.py --os=linux --build=full
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/retrofe
    cp -r Artifacts/linux/RetroFE $out/share/retrofe/example
    mv $out/share/retrofe/example/retrofe $out/bin/

    cat > $out/bin/retrofe-init << EOF
    #!/bin/sh

    echo "This will install retrofe's example files into this directory"
    echo "Example files location: $out/share/retrofe/example/"

    while true; do
        read -p "Do you want to proceed? [yn] " yn
        case \$yn in
            [Yy]* ) cp -r --no-preserve=all $out/share/retrofe/example/* .; break;;
            [Nn]* ) exit;;
            * ) echo "Please answer with yes or no.";;
        esac
    done
    EOF

    chmod +x $out/bin/retrofe-init

    runHook postInstall
  '';

  # retrofe will look for config files in its install path ($out/bin).
  # When set it will use $RETROFE_PATH instead. Sadly this behaviour isn't
  # documented well. To make it behave more like as expected it's set to
  # $PWD by default here.
  postInstall = ''
    wrapProgram "$out/bin/retrofe" \
      --prefix GST_PLUGIN_PATH : "$GST_PLUGIN_SYSTEM_PATH_1_0" \
      --set    RETROFE_PATH      "\''${RETROFE_PATH:-\$PWD}"
  '';

  meta = with stdenv.lib; {
    description = "A frontend for arcade cabinets and media PCs";
    homepage = http://retrofe.com;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hrdinka ];
    platforms = with platforms; linux;
  };
}

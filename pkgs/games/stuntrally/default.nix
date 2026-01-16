{
  lib,
  fetchFromGitHub,
  stdenv,
  cmake,
  boost,
  ogre-next_3,
  mygui-next,
  ois,
  SDL2,
  libX11,
  libvorbis,
  pkg-config,
  makeWrapper,
  enet,
  libXcursor,
  bullet,
  openal,
  tinyxml,
  tinyxml-2,
  rapidjson,
}:

let
  stuntrally_ogre = ogre-next_3.overrideAttrs (old: {
    cmakeFlags = old.cmakeFlags ++ [
      "-DOGRE_NODELESS_POSITIONING=ON"
      "-DOGRE_RESOURCEMANAGER_STRICT=0"
      "-DOGRE_BUILD_COMPONENT_PLANAR_REFLECTIONS=1"
      "-DOGRE_CONFIG_THREAD_PROVIDER=0"
      "-DOGRE_CONFIG_THREADS=0"
    ];
  });
  stuntrally_mygui = (
    mygui-next.override {
      withOgre = true;
      ogre = stuntrally_ogre;
    }
  );
in

stdenv.mkDerivation rec {
  pname = "stuntrally";
  version = "3.3";

  src = fetchFromGitHub {
    owner = "stuntrally";
    repo = "stuntrally3";
    rev = version;
    hash = "sha256-BJMMsJ/ONZTpvXetaaHlgm6rih9oZmtJNBXv0IM855Y=";
  };
  tracks = fetchFromGitHub {
    owner = "stuntrally";
    repo = "tracks3";
    rev = version;
    hash = "sha256-nvIN5hIfTfnuJdlLNlmpmYo3WQhUxYWz14OFra/55w4=";
  };

  preConfigure = ''
    ln -s ${tracks}/ data/tracks

    # Create FindOGRE.cmake to locate Ogre3 via pkg-config
    cat > CMake/FindOGRE.cmake <<EOF
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(OGRE_PC REQUIRED OGRE)

    find_path(OGRE_INCLUDE_DIRS NAMES Ogre.h HINTS \''${OGRE_PC_INCLUDE_DIRS})
    find_library(OGRE_LIBRARY NAMES OgreMain HINTS \''${OGRE_PC_LIBRARY_DIRS})
    find_library(OGRE_HLMS_PBS_LIB NAMES OgreHlmsPbs HINTS \''${OGRE_PC_LIBRARY_DIRS})
    find_library(OGRE_HLMS_UNLIT_LIB NAMES OgreHlmsUnlit HINTS \''${OGRE_PC_LIBRARY_DIRS})
    find_library(OGRE_OVERLAY_LIB NAMES OgreOverlay HINTS \''${OGRE_PC_LIBRARY_DIRS})

    set(OGRE_LIBRARIES \''${OGRE_LIBRARY} \''${OGRE_HLMS_PBS_LIB} \''${OGRE_HLMS_UNLIT_LIB} \''${OGRE_OVERLAY_LIB})

    include(FindPackageHandleStandardArgs)
    find_package_handle_standard_args(OGRE DEFAULT_MSG OGRE_LIBRARIES OGRE_INCLUDE_DIRS)

    if(OGRE_FOUND)
        if(NOT TARGET OGRE::OGRE)
            add_library(OGRE::OGRE UNKNOWN IMPORTED)
            set_target_properties(OGRE::OGRE PROPERTIES
                IMPORTED_LOCATION "\''${OGRE_LIBRARY}"
                INTERFACE_LINK_LIBRARIES "\''${OGRE_HLMS_PBS_LIB};\''${OGRE_HLMS_UNLIT_LIB};\''${OGRE_OVERLAY_LIB}"
                INTERFACE_INCLUDE_DIRECTORIES "\''${OGRE_INCLUDE_DIRS}"
                INTERFACE_COMPILE_OPTIONS "\''${OGRE_PC_CFLAGS_OTHER}"
            )
        endif()
    endif()
    EOF
  '';

  env.NIX_CFLAGS_COMPILE = "-I${stuntrally_ogre}/include/OGRE/Hlms/Common -I${stuntrally_ogre}/include/OGRE/Hlms/Unlit -I${stuntrally_ogre}/include/OGRE/Hlms/Pbs -I${stuntrally_ogre}/include/OGRE/Overlay";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share/stuntrally3

    # Copy binaries
    install -m755 ../bin/Release/stuntrally3 $out/bin/
    install -m755 ../bin/Release/sr-editor3 $out/bin/

    # Copy data and config
    cp -r ../data $out/share/stuntrally3/
    cp -r ../config $out/share/stuntrally3/

    # Symlink to root for relative path lookup
    ln -s $out/share/stuntrally3/data $out/data
    ln -s $out/share/stuntrally3/config $out/config

    # Generate plugins.cfg
    echo "PluginFolder=${stuntrally_ogre}/lib/OGRE" > $out/share/stuntrally3/plugins.cfg
    echo "Plugin=RenderSystem_GL3Plus" >> $out/share/stuntrally3/plugins.cfg
    echo "Plugin=Plugin_ParticleFX" >> $out/share/stuntrally3/plugins.cfg

    # Wrap binaries to find data and force X11
    for bin in stuntrally3 sr-editor3; do
      wrapProgram $out/bin/$bin \
        --chdir "$out/share/stuntrally3" \
        --set SDL_VIDEODRIVER x11
    done

    runHook postInstall
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];
  buildInputs = [
    boost
    stuntrally_ogre
    stuntrally_mygui
    ois
    SDL2
    libX11
    libvorbis
    enet
    libXcursor
    bullet
    openal
    tinyxml
    tinyxml-2
    rapidjson
  ];

  meta = with lib; {
    description = "Stunt Rally game with Track Editor, based on VDrift and OGRE";
    homepage = "http://stuntrally.tuxfamily.org/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
    mainProgram = "stuntrally3";
  };
}

{ stdenv, fetchFromGitHub, which, pkgconfig, makeWrapper
, ffmpeg, libGLU_combined, freetype, libxml2, python3
, libobjc, AppKit, Foundation
, alsaLib ? null
, libpulseaudio ? null
, libv4l ? null
, libX11 ? null
, libXdmcp ? null
, libXext ? null
, libXxf86vm ? null
, SDL2 ? null
, udev ? null
, enableNvidiaCgToolkit ? false, nvidia_cg_toolkit ? null
, withVulkan ? stdenv.isLinux, vulkan-loader ? null
, fetchurl
}:

with stdenv.lib;

let

  # ibtool is closed source so we have to download the blob
  osx-MainMenu = fetchurl {
    url = "https://github.com/matthewbauer/RetroArch/raw/b146a9ac6b2b516652a7bf05a9db5a804eab323d/pkg/apple/OSX/en.lproj/MainMenu.nib";
    sha256 = "13k1l628wy0rp6wxrpwr4g1m9c997d0q8ks50f8zhmh40l5j2sp8";
  };

in stdenv.mkDerivation rec {
  name = "retroarch-bare-${version}";
  version = "1.7.5";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "RetroArch";
    sha256 = "1jfpgl34jjxn3dvxd1kd564swkw7v98hnn562v998b7vllz3dxdm";
    rev = "v${version}";
  };

  nativeBuildInputs = [ pkgconfig ]
                      ++ optional withVulkan [ makeWrapper ];

  buildInputs = [ ffmpeg freetype libxml2 libGLU_combined python3 SDL2 which ]
                ++ optional enableNvidiaCgToolkit nvidia_cg_toolkit
                ++ optional withVulkan [ vulkan-loader ]
                ++ optionals stdenv.isDarwin [ libobjc AppKit Foundation ]
                ++ optionals stdenv.isLinux [ alsaLib libpulseaudio libv4l libX11
                                              libXdmcp libXext libXxf86vm udev ];

  enableParallelBuilding = true;

  postInstall = optionalString withVulkan ''
    wrapProgram $out/bin/retroarch --prefix LD_LIBRARY_PATH ':' ${vulkan-loader}/lib
  '' + optionalString stdenv.targetPlatform.isDarwin ''
    EXECUTABLE_NAME=RetroArch
    PRODUCT_NAME=RetroArch
    MACOSX_DEPLOYMENT_TARGET=10.5
    app=$out/Applications/$PRODUCT_NAME.app

    install -D pkg/apple/OSX/Info.plist $app/Contents/Info.plist
    echo "APPL????" > $app/Contents/PkgInfo
    mkdir -p $app/Contents/MacOS
    ln -s $out/bin/retroarch $app/Contents/MacOS/$EXECUTABLE_NAME

    # Hack to fill in Info.plist template w/o using xcode
    sed -i -e 's,''${EXECUTABLE_NAME}'",$EXECUTABLE_NAME," \
           -e 's,''${MACOSX_DEPLOYMENT_TARGET}'",$MACOSX_DEPLOYMENT_TARGET," \
           -e 's,''${PRODUCT_NAME}'",$PRODUCT_NAME," \
           -e 's,''${PRODUCT_NAME:rfc1034identifier}'",$PRODUCT_NAME," \
           $app/Contents/Info.plist

    install -D ${osx-MainMenu} \
               $app/Contents/Resources/en.lproj/MainMenu.nib
    install -D pkg/apple/OSX/en.lproj/InfoPlist.strings \
               $app/Contents/Resources/en.lproj/InfoPlist.strings
    install -D media/retroarch.icns $app/Contents/Resources/retroarch.icns
  '';

  preFixup = "rm $out/bin/retroarch-cg2glsl";

  meta = {
    homepage = https://libretro.com;
    description = "Multi-platform emulator frontend for libretro cores";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ MP2E edwtjo matthewbauer ];
  };
}

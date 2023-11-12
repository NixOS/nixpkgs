{ lib
, stdenv
, fetchFromGitHub
, fetchurl
, cmake
, pkg-config
, glfw3
, glew
, enet
, cglm
, openal
, libdeflate
, libX11
, libXau
, libXdmcp
, libSM
, libXext
, makeDesktopItem
, copyDesktopItems
, dos2unix
, bsresources ? (fetchurl {
    url = "https://web.archive.org/web/20230713144634/https://aos.party/bsresources.zip";
    sha256 = "0j3z5jzra9p3wjl1mdnx0mji9m1fnc7xfax5a5xj45z3xbc7v2jz";
  })
}:

let
  betterspades-v.version = "0.1.5";
  betterspades-v.sha256 = "a+Zsn6zB7P3i4v3XhNrVh0MwqBDZIN6XwcSN4xW0eEI=";

  srcs =
    let
      ver = {
        ini.commit = "9cecf0643da0846e77f64d10a126d9f48b9e05e8";
        ini.sha256 = "a4nvhJSmZGqu2sdZSPNPjdnkzZ9dSKocL/XG2aDyFw4=";

        lodepng.commit = "c18b949b71f45e78b1f9a28c5d458bce0da505d6";
        lodepng.sha256 = "AAw6I+MxDaxmGpjC5efxuBNw7Lx8FXwg2TEfl6LfPfQ=";

        parson.commit = "fd02ea0c56e14cce9d4114c06b5a0d5e427fe4d8";
        parson.sha256 = "A6QyS/im2UWq6bZPLDYxNOlg6rqnCV4h6KT4j7eSago=";

        log.commit = "3bc4cee8782b08faf24d0c1d52064afe0ad6c949";
        log.sha256 = "dw9bTUl96fQjoH3C4wNvyJXY585BQ22fPOmw08fAooM=";

        hashtable.commit = "86fc717c498572834535284d4a9cc78c3ffd7aed";
        hashtable.sha256 = "VPkJeE9dNCcBDOHbd31sSwrm/uu1rJGPSCgRo6K3s1U=";

        microui.commit = "05d7b46c9cf650dd0c5fbc83a9bebf87c80d02a5";
        microui.sha256 = "bH6o8LuiagifslZWdWUgkA96P/ngTz4qtFiy3i+AQ+U=";

        libvxl.rev = "64ae0fc950d331491cdb56359d51a866b33e20d2";
        libvxl.sha256 = "3rMqPbXXDon6oppBEYIWboJXB+AbhybJKUyXkypf0NU=";

        dr_wav.commit = "1d7ae742f4ee890f9a974ff155ead9403127fac3";
        dr_wav.sha256 = "sha256-jxdH/ajlrDq19TyM1J5SeAx3oTJWh9zCz9aaHUdFxvI=";

        stb_truetype.commit = "5736b15f7ea0ffb08dd38af21067c314d6a3aae9";
        stb_truetype.sha256 = "09grhj1h9lqi9xf5krnca8adzx61453m4bdbcf8iphg7di9qskd3";

        http.commit = "a6456b8e7f1564b0c94c329509fe9652bb5a096b";
        http.sha256 = "19qhzr6pzrq5dpjra2pc4aj7636kywbqzdwxa5lkjn6m1yp6zlm1";

        libdeflate.commit = "8e25ebe07c3514f8379187fefb61ed308557fc11";
        libdeflate.sha256 = "0c9sp616acplfms5gkffv06wa2j2h72q5b5ppphq2h8i8pl8jmjs";
      };
    in
    {
      betterspades = fetchFromGitHub {
        owner = "xtreme8000";
        repo = "BetterSpades";
        rev = "v${betterspades-v.version}";
        sha256 = betterspades-v.sha256;
      };

      libvxl = fetchFromGitHub {
        owner = "xtreme8000";
        repo = "libvxl";
        rev = ver.libvxl.rev;
        sha256 = ver.libvxl.sha256;
      };

      ini = fetchFromGitHub {
        owner = "benhoyt";
        repo = "inih";
        rev = ver.ini.commit;
        sha256 = ver.ini.sha256;
      };

      lodepng = fetchFromGitHub {
        owner = "lvandeve";
        repo = "lodepng";
        rev = ver.lodepng.commit;
        sha256 = ver.lodepng.sha256;
      };

      "dr_wav.c" = fetchurl {
        url = "https://raw.githubusercontent.com/mackron/dr_libs/${ver.dr_wav.commit}/dr_wav.h";
        sha256 = ver.dr_wav.sha256;
      };

      "stb_truetype.h" = fetchurl {
        url = "https://raw.githubusercontent.com/nothings/stb/${ver.stb_truetype.commit}/stb_truetype.h";
        sha256 = ver.stb_truetype.sha256;
      };

      parson = fetchFromGitHub {
        owner = "kgabis";
        repo = "parson";
        rev = ver.parson.commit;
        sha256 = ver.parson.sha256;
      };

      "http.h" = fetchurl {
        url = "https://raw.githubusercontent.com/mattiasgustavsson/libs/${ver.http.commit}/http.h";
        sha256 = ver.http.sha256;
      };

      log = fetchFromGitHub {
        owner = "xtreme8000";
        repo = "log.c";
        rev = ver.log.commit;
        sha256 = ver.log.sha256;
      };

      hashtable = fetchFromGitHub {
        owner = "goldsborough";
        repo = "hashtable";
        rev = ver.hashtable.commit;
        sha256 = ver.hashtable.sha256;
      };

      "libdeflate.h" = fetchurl {
        url = "https://raw.githubusercontent.com/ebiggers/libdeflate/${ver.libdeflate.commit}/libdeflate.h";
        sha256 = ver.libdeflate.sha256;
      };

      microui = fetchFromGitHub {
        owner = "rxi";
        repo = "microui";
        rev = ver.microui.commit;
        sha256 = ver.microui.sha256;
      };
    };
in
stdenv.mkDerivation rec {
  pname = "betterspades";
  inherit (betterspades-v) version;

  src = srcs.betterspades;

  nativeBuildInputs = [ cmake pkg-config copyDesktopItems dos2unix ];

  buildInputs = [
    glfw3
    glew
    enet
    cglm
    openal
    libdeflate
    libX11
    libXau
    libXdmcp
    libSM
    libXext
  ];

  cmakeFlags = [
    "-DFETCHCONTENT_SOURCE_DIR_VXL=${srcs.libvxl}"
    "-DFETCHCONTENT_SOURCE_DIR_CGLM=${cglm.src}"
  ];

  # all .c and .h files in repo have CRLF line endings. This makes patching difficult.
  prePatch = ''
    find . -name '*.c' -or -name '*.h' -exec dos2unix {} +
  '';

  patches = [
    ./001-dont-install-OpenAL32.dll.patch
    ./002-fix-macos-build.patch
  ];

  postUnpack = ''
    cp "${srcs.ini}/ini.c" source/src/ini.c
    cp "${srcs.ini}/ini.h" source/src/ini.h

    install -D "${srcs.lodepng}/lodepng.cpp" source/src/lodepng/lodepng.c
    install -D "${srcs.lodepng}/lodepng.h" source/src/lodepng/lodepng.h

    cp ${srcs."dr_wav.c"} source/src/dr_wav.c

    cp ${srcs."stb_truetype.h"} source/src/stb_truetype.h

    cp "${srcs.parson}/parson.c" source/src/parson.c
    cp "${srcs.parson}/parson.h" source/src/parson.h

    cp ${srcs."http.h"} source/src/http.h

    cp "${srcs.log}/src/log.c" source/src/log.c
    cp "${srcs.log}/src/log.h" source/src/log.h

    cp "${srcs.hashtable}/hashtable.c" source/src/hashtable.c
    cp "${srcs.hashtable}/hashtable.h" source/src/hashtable.h

    cp ${srcs."libdeflate.h"} source/deps/libdeflate.h

    cp ${bsresources} source/bsresources.zip

    cp "${srcs.microui}/src/microui.c" source/src/microui.c
    cp "${srcs.microui}/src/microui.h" source/src/microui.h
  '';

  postInstall = ''
      cd $out
      rm -rf cache/ include/ lib/ logs/ screenshots/ config.ini
      mkdir -p bin
      mv client bin/.betterspades-wrapped
      mkdir -p share/data
      mv fonts/ kv6/ png/ wav/ share/data
      mkdir -p share/icons/hicolor/256x256/apps
      cp "${src}/resources/icon.png" share/icons/hicolor/256x256/apps/betterspades.png
      cp "${src}/resources/config.ini" share/data/config.ini
      cp ${./wrapper.sh} bin/betterspades
      chmod +x bin/betterspades
  '';

  desktopItems =
    let
      desktop = {
        comment = meta.description;
        genericName = "Sandbox building and FPS videogame";
        icon = pname;
        categories = [ "Game" "ActionGame" ];
        keywords = [ "game" "fps" "sandbox" "voxel" "aos" ];
        prefersNonDefaultGPU = true;
      };
      desktop_name = "BetterSpades";
    in
    [
      (makeDesktopItem ({
        name = pname;
        desktopName = desktop_name;
        exec = "betterspades";
      } // desktop))

      (makeDesktopItem ({
        name = "${pname}.aosProtocolHandler";
        desktopName = "${desktop_name} (protocol handler)";
        exec = "betterspades -%U";
        mimeTypes = [ "x-scheme-handler/aos" ];
        noDisplay = true;
      } // desktop))
    ];

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Ace of Spades 0.75 client targeted at low end systems";
    homepage = "https://github.com/xtreme8000/BetterSpades/";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ _3JlOy-PYCCKUi ];
  };
}

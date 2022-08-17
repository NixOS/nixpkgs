{ lib
, stdenv
, fetchFromGitHub
, fetchurl
, substituteAll
, coreutils
, curl
, glxinfo
, gnugrep
, gnused
, xdg-utils
, dbus
, hwdata
, libX11
, mangohud32
, vulkan-headers
, appstream
, glslang
, makeWrapper
, Mako
, meson
, ninja
, pkg-config
, unzip
, vulkan-loader
, libXNVCtrl
, wayland
, glew
, glfw
, nlohmann_json
, xorg
, addOpenGLRunpath
, gamescopeSupport ? true # build mangoapp and mangohudctl
}:

let
  # Derived from subprojects/imgui.wrap
  imgui = rec {
    version = "1.81";
    src = fetchFromGitHub {
      owner = "ocornut";
      repo = "imgui";
      rev = "refs/tags/v${version}";
      sha256 = "sha256-rRkayXk3xz758v6vlMSaUu5fui6NR8Md3njhDB0gJ18=";
    };
    patch = fetchurl {
      url = "https://wrapdb.mesonbuild.com/v2/imgui_${version}-1/get_patch";
      sha256 = "sha256-bQC0QmkLalxdj4mDEdqvvOFtNwz2T1MpTDuMXGYeQ18=";
    };
  };

  # Derived from subprojects/spdlog.wrap
  #
  # NOTE: We only statically link spdlog due to a bug in pressure-vessel:
  # https://github.com/ValveSoftware/steam-runtime/issues/511
  #
  # Once this fix is released upstream, we should switch back to using
  # the system provided spdlog
  spdlog = rec {
    version = "1.8.5";
    src = fetchFromGitHub {
      owner = "gabime";
      repo = "spdlog";
      rev = "refs/tags/v${version}";
      sha256 = "sha256-D29jvDZQhPscaOHlrzGN1s7/mXlcsovjbqYpXd7OM50=";
    };
    patch = fetchurl {
      url = "https://wrapdb.mesonbuild.com/v2/spdlog_${version}-1/get_patch";
      sha256 = "sha256-PDjyddV5KxKGORECWUMp6YsXc3kks0T5gxKrCZKbdL4=";
    };
  };
in stdenv.mkDerivation rec {
  pname = "mangohud";
  version = "0.6.8";

  src = fetchFromGitHub {
    owner = "flightlessmango";
    repo = "MangoHud";
    rev = "refs/tags/v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-jfmgN90kViHa7vMOjo2x4bNY2QbLk93uYEvaA4DxYvg=";
  };

  outputs = [ "out" "doc" "man" ];

  # Unpack subproject sources
  postUnpack = ''(
    cd "$sourceRoot/subprojects"
    cp -R --no-preserve=mode,ownership ${imgui.src} imgui-${imgui.version}
    cp -R --no-preserve=mode,ownership ${spdlog.src} spdlog-${spdlog.version}
  )'';

  patches = [
    # Hard code dependencies. Can't use makeWrapper since the Vulkan
    # layer can be used without the mangohud executable by setting MANGOHUD=1.
    (substituteAll {
      src = ./hardcode-dependencies.patch;

      path = lib.makeBinPath [
        coreutils
        curl
        glxinfo
        gnugrep
        gnused
        xdg-utils
      ];

      libdbus = dbus.lib;
      inherit hwdata libX11;
    })
  ] ++ lib.optional (stdenv.hostPlatform.system == "x86_64-linux") [
    # Support 32bit OpenGL applications by appending the mangohud32
    # lib path to LD_LIBRARY_PATH.
    #
    # This workaround is necessary since on Nix's build of ld.so, $LIB
    # always expands to lib even when running an 32bit application.
    #
    # See https://github.com/NixOS/nixpkgs/issues/101597.
    (substituteAll {
      src = ./opengl32-nix-workaround.patch;
      inherit mangohud32;
    })
  ];

  postPatch = ''(
    cd subprojects
    unzip ${imgui.patch}
    unzip ${spdlog.patch}
  )'';

  mesonFlags = [
    "-Duse_system_vulkan=enabled"
    "-Dvulkan_datadir=${vulkan-headers}/share"
    "-Dwith_wayland=enabled"
  ] ++ lib.optionals gamescopeSupport [
    "-Dmangoapp_layer=true"
    "-Dmangoapp=true"
    "-Dmangohudctl=true"
  ];

  nativeBuildInputs = [
    appstream
    glslang
    makeWrapper
    Mako
    meson
    ninja
    pkg-config
    unzip
    vulkan-loader
  ];

  buildInputs = [
    dbus
    libX11
    libXNVCtrl
    wayland
  ] ++ lib.optionals gamescopeSupport [
    glew
    glfw
    nlohmann_json
    vulkan-headers
    xorg.libXrandr
  ];

  # Support 32bit Vulkan applications by linking in 32bit Vulkan layer
  # This is needed for the same reason the 32bit OpenGL workaround is needed.
  postInstall = lib.optionalString (stdenv.hostPlatform.system == "x86_64-linux") ''
    ln -s ${mangohud32}/share/vulkan/implicit_layer.d/MangoHud.json \
      "$out/share/vulkan/implicit_layer.d/MangoHud.x86.json"
  '';

  # Support Nvidia cards by adding OpenGL path and support overlaying
  # Vulkan applications without requiring MangoHud to be installed
  postFixup = ''
    wrapProgram "$out/bin/mangohud" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ addOpenGLRunpath.driverLink ]} \
      --prefix XDG_DATA_DIRS : "$out/share"
  '' + lib.optionalString (gamescopeSupport) ''
    if [[ -e "$out/bin/mangoapp" ]]; then
      wrapProgram "$out/bin/mangoapp" \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ addOpenGLRunpath.driverLink ]} \
        --prefix XDG_DATA_DIRS : "$out/share"
    fi
  '';

  meta = with lib; {
    description = "A Vulkan and OpenGL overlay for monitoring FPS, temperatures, CPU/GPU load and more";
    homepage = "https://github.com/flightlessmango/MangoHud";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ kira-bruneau zeratax ];
  };
}

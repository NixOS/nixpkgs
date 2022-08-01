{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, fetchurl
, substituteAll
, coreutils
, curl
, gawk
, glxinfo
, gnugrep
, gnused
, lsof
, xdg-utils
, dbus
, hwdata
, libX11
, mangohud32
, vulkan-headers
, glslang
, makeWrapper
, meson
, ninja
, pkg-config
, python3Packages
, unzip
, vulkan-loader
, libXNVCtrl
, wayland
, spdlog
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
      rev = "v${version}";
      hash = "sha256-rRkayXk3xz758v6vlMSaUu5fui6NR8Md3njhDB0gJ18=";
    };
    patch = fetchurl {
      url = "https://wrapdb.mesonbuild.com/v2/imgui_${version}-1/get_patch";
      hash = "sha256-bQC0QmkLalxdj4mDEdqvvOFtNwz2T1MpTDuMXGYeQ18=";
    };
  };
in stdenv.mkDerivation rec {
  pname = "mangohud";
  version = "0.6.7-1";

  src = fetchFromGitHub {
    owner = "flightlessmango";
    repo = "MangoHud";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-60cZYo+d679KRggLBGbpLYM5Iu1XySEEGp+MxZs6wF0=";
  };

  outputs = [ "out" "doc" "man" ];

  # Unpack subproject sources
  postUnpack = ''(
    cd "$sourceRoot/subprojects"
    cp -R --no-preserve=mode,ownership ${imgui.src} imgui-${imgui.version}
    unzip ${imgui.patch}
  )'';

  patches = [
    # Hard code dependencies. Can't use makeWrapper since the Vulkan
    # layer can be used without the mangohud executable by setting MANGOHUD=1.
    (substituteAll {
      src = ./hardcode-dependencies.patch;

      path = lib.makeBinPath [
        coreutils
        curl
        gawk
        glxinfo
        gnugrep
        gnused
        lsof
        xdg-utils
      ];

      libdbus = dbus.lib;
      inherit hwdata libX11;
    })

    (fetchpatch {
      name = "allow-system-nlohmann-json.patch";
      url = "https://github.com/flightlessmango/MangoHud/commit/e1ffa0f85820abea44639438fca2152290c87ee8.patch";
      sha256 = "sha256-CaJb0RpXmNGCBidMXM39VJVLIXb6NbN5HXWkH/5Sfvo=";
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

  mesonFlags = [
    "-Duse_system_vulkan=enabled"
    "-Dvulkan_datadir=${vulkan-headers}/share"
    "-Dwith_wayland=enabled"
    "-Duse_system_spdlog=enabled"
  ] ++ lib.optionals gamescopeSupport [
    "-Dmangoapp_layer=true"
    "-Dmangoapp=true"
    "-Dmangohudctl=true"
  ];

  nativeBuildInputs = [
    glslang
    makeWrapper
    meson
    ninja
    pkg-config
    python3Packages.Mako
    python3Packages.python
    unzip
    vulkan-loader
  ];

  buildInputs = [
    dbus
    libX11
    libXNVCtrl
    wayland
    spdlog
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

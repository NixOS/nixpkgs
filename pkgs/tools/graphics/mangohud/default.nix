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
, mangohud32
, addOpenGLRunpath
, glslang
, mako
, meson
, ninja
, pkg-config
, unzip
, libXNVCtrl
, wayland
, libX11
, nlohmann_json
, spdlog
, glew
, glfw
, xorg
, gamescopeSupport ? true # build mangoapp and mangohudctl
, nix-update-script
}:

let
  # Derived from subprojects/imgui.wrap
  imgui = rec {
    version = "1.81";
    src = fetchFromGitHub {
      owner = "ocornut";
      repo = "imgui";
      rev = "refs/tags/v${version}";
      hash = "sha256-rRkayXk3xz758v6vlMSaUu5fui6NR8Md3njhDB0gJ18=";
    };
    patch = fetchurl {
      url = "https://wrapdb.mesonbuild.com/v2/imgui_${version}-1/get_patch";
      hash = "sha256-bQC0QmkLalxdj4mDEdqvvOFtNwz2T1MpTDuMXGYeQ18=";
    };
  };

  # Derived from subprojects/vulkan-headers.wrap
  vulkan-headers = rec {
    version = "1.2.158";
    src = fetchFromGitHub {
      owner = "KhronosGroup";
      repo = "Vulkan-Headers";
      rev = "v${version}";
      hash = "sha256-5uyk2nMwV1MjXoa3hK/WUeGLwpINJJEvY16kc5DEaks=";
    };
    patch = fetchurl {
      url = "https://wrapdb.mesonbuild.com/v2/vulkan-headers_${version}-2/get_patch";
      hash = "sha256-hgNYz15z9FjNHoj4w4EW0SOrQh1c4uQSnsOOrt2CDhc=";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mangohud";
  version = "0.6.9";

  src = fetchFromGitHub {
    owner = "flightlessmango";
    repo = "MangoHud";
    rev = "refs/tags/v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-wvidO9LAZwVUZhYYWnelSiP0Q1WTPoCg6pMXsoJBPPg=";
  };

  outputs = [ "out" "doc" "man" ];

  # Unpack subproject sources
  postUnpack = ''(
    cd "$sourceRoot/subprojects"
    cp -R --no-preserve=mode,ownership ${imgui.src} imgui-${imgui.version}
    cp -R --no-preserve=mode,ownership ${vulkan-headers.src} Vulkan-Headers-${vulkan-headers.version}
  )'';

  patches = [
    # Add @libraryPath@ template variable to fix loading the preload
    # library and @dataPath@ to support overlaying Vulkan apps without
    # requiring MangoHud to be installed
    ./preload-nix-workaround.patch

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
      inherit hwdata;
    })
  ];

  postPatch = ''
    substituteInPlace bin/mangohud.in \
      --subst-var-by libraryPath ${lib.makeSearchPath "lib/mangohud" ([
        (placeholder "out")
      ] ++ lib.optionals (stdenv.hostPlatform.system == "x86_64-linux") [
        mangohud32
      ])} \
      --subst-var-by dataDir ${placeholder "out"}/share

    (
      cd subprojects
      unzip ${imgui.patch}
      unzip ${vulkan-headers.patch}
    )
  '';

  mesonFlags = [
    "-Dwith_wayland=enabled"
    "-Duse_system_spdlog=enabled"
    "-Dtests=disabled" # Tests require AMD GPU
  ] ++ lib.optionals gamescopeSupport [
    "-Dmangoapp=true"
    "-Dmangoapp_layer=true"
    "-Dmangohudctl=true"
  ];

  nativeBuildInputs = [
    addOpenGLRunpath
    glslang
    mako
    meson
    ninja
    pkg-config
    unzip

    # Only the headers are used from these packages
    # The corresponding libraries are loaded at runtime from the app's runpath
    libXNVCtrl
    wayland
    libX11
  ];

  buildInputs = [
    dbus
    nlohmann_json
    spdlog
  ] ++ lib.optionals gamescopeSupport [
    glew
    glfw
    xorg.libXrandr
  ];

  # Support 32bit Vulkan applications by linking in 32bit Vulkan layers
  # This is needed for the same reason the 32bit preload workaround is needed.
  postInstall = lib.optionalString (stdenv.hostPlatform.system == "x86_64-linux") ''
    ln -s ${mangohud32}/share/vulkan/implicit_layer.d/MangoHud.x86.json \
      "$out/share/vulkan/implicit_layer.d"

    ${lib.optionalString gamescopeSupport ''
      ln -s ${mangohud32}/share/vulkan/implicit_layer.d/libMangoApp.x86.json \
        "$out/share/vulkan/implicit_layer.d"
    ''}
  '';

  # Add OpenGL driver path to RUNPATH to support NVIDIA cards
  postFixup = ''
    addOpenGLRunpath "$out/lib/mangohud/libMangoHud.so"
    ${lib.optionalString gamescopeSupport ''
      addOpenGLRunpath "$out/bin/mangoapp"
    ''}
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A Vulkan and OpenGL overlay for monitoring FPS, temperatures, CPU/GPU load and more";
    homepage = "https://github.com/flightlessmango/MangoHud";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ kira-bruneau zeratax ];
  };
})

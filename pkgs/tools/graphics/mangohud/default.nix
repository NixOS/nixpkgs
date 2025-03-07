{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  replaceVars,
  coreutils,
  curl,
  gnugrep,
  gnused,
  xdg-utils,
  dbus,
  hwdata,
  mangohud32,
  addDriverRunpath,
  appstream,
  glslang,
  mako,
  meson,
  ninja,
  pkg-config,
  unzip,
  libX11,
  libXNVCtrl,
  wayland,
  nlohmann_json,
  spdlog,
  glew,
  glfw,
  xorg,
  gamescopeSupport ? true, # build mangoapp and mangohudctl
  lowerBitnessSupport ? stdenv.hostPlatform.isx86_64, # Support 32 bit on 64bit
  nix-update-script,
  libxkbcommon,
}:

let
  # Derived from subprojects/imgui.wrap
  imgui = rec {
    version = "1.89.9";
    src = fetchFromGitHub {
      owner = "ocornut";
      repo = "imgui";
      tag = "v${version}";
      hash = "sha256-0k9jKrJUrG9piHNFQaBBY3zgNIKM23ZA879NY+MNYTU=";
    };
    patch = fetchurl {
      url = "https://wrapdb.mesonbuild.com/v2/imgui_${version}-1/get_patch";
      hash = "sha256-myEpDFl9dr+NTus/n/oCSxHZ6mxh6R1kjMyQtChD1YQ=";
    };
  };

  # Derived from subprojects/implot.wrap
  implot = rec {
    version = "0.16";
    src = fetchFromGitHub {
      owner = "epezent";
      repo = "implot";
      tag = "v${version}";
      hash = "sha256-/wkVsgz3wiUVZBCgRl2iDD6GWb+AoHN+u0aeqHHgem0=";
    };
    patch = fetchurl {
      url = "https://wrapdb.mesonbuild.com/v2/implot_${version}-1/get_patch";
      hash = "sha256-HGsUYgZqVFL6UMHaHdR/7YQfKCMpcsgtd48pYpNlaMc=";
    };
  };

  # Derived from subprojects/vulkan-headers.wrap
  vulkan-headers = rec {
    version = "1.2.158";
    src = fetchFromGitHub {
      owner = "KhronosGroup";
      repo = "Vulkan-Headers";
      tag = "v${version}";
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
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "flightlessmango";
    repo = "MangoHud";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-FvPhnOvcYE8vVB5R+ZRmuZxrC9U4GA338V7VAuUlHCE=";
  };

  outputs = [
    "out"
    "doc"
    "man"
  ];

  # Unpack subproject sources
  postUnpack = ''
    (
      cd "$sourceRoot/subprojects"
      cp -R --no-preserve=mode,ownership ${imgui.src} imgui-${imgui.version}
      cp -R --no-preserve=mode,ownership ${implot.src} implot-${implot.version}
      cp -R --no-preserve=mode,ownership ${vulkan-headers.src} Vulkan-Headers-${vulkan-headers.version}
    )
  '';

  patches = [
    # Add @libraryPath@ template variable to fix loading the preload
    # library and @dataPath@ to support overlaying Vulkan apps without
    # requiring MangoHud to be installed
    ./preload-nix-workaround.patch

    # Hard code dependencies. Can't use makeWrapper since the Vulkan
    # layer can be used without the mangohud executable by setting MANGOHUD=1.
    (replaceVars ./hardcode-dependencies.patch {
      path = lib.makeBinPath [
        coreutils
        curl
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
      --subst-var-by libraryPath ${
        lib.makeSearchPath "lib/mangohud" (
          [
            (placeholder "out")
          ]
          ++ lib.optional lowerBitnessSupport mangohud32
        )
      } \
      --subst-var-by version "${finalAttrs.version}" \
      --subst-var-by dataDir ${placeholder "out"}/share

    (
      cd subprojects
      unzip ${imgui.patch}
      unzip ${implot.patch}
      unzip ${vulkan-headers.patch}
    )
  '';

  mesonFlags =
    [
      "-Dwith_wayland=enabled"
      "-Duse_system_spdlog=enabled"
      "-Dtests=disabled" # amdgpu test segfaults in nix sandbox
    ]
    ++ lib.optionals gamescopeSupport [
      "-Dmangoapp=true"
      "-Dmangohudctl=true"
    ];

  nativeBuildInputs = [
    addDriverRunpath
    glslang
    mako
    meson
    ninja
    pkg-config
    unzip

    # Only the headers are used from these packages
    # The corresponding libraries are loaded at runtime from the app's runpath
    libX11
    libXNVCtrl
    wayland
  ];

  buildInputs =
    [
      dbus
      nlohmann_json
      spdlog
    ]
    ++ lib.optionals gamescopeSupport [
      glew
      glfw
      xorg.libXrandr
      libxkbcommon
    ];

  doCheck = true;

  nativeCheckInputs = [
    appstream
  ];

  # Support 32bit Vulkan applications by linking in 32bit Vulkan layers
  # This is needed for the same reason the 32bit preload workaround is needed.
  postInstall = lib.optionalString lowerBitnessSupport ''
    ln -s ${mangohud32}/share/vulkan/implicit_layer.d/MangoHud.x86.json \
      "$out/share/vulkan/implicit_layer.d"
  '';

  postFixup =
    let
      archMap = {
        "x86_64-linux" = "x86_64";
        "i686-linux" = "x86";
      };
      layerPlatform = archMap."${stdenv.hostPlatform.system}" or null;
    in
    # We need to give the different layers separate names or else the loader
    # might try the 32-bit one first, fail and not attempt to load the 64-bit
    # layer under the same name.
    lib.optionalString (layerPlatform != null) ''
      substituteInPlace $out/share/vulkan/implicit_layer.d/MangoHud.${layerPlatform}.json \
        --replace-fail "VK_LAYER_MANGOHUD_overlay" "VK_LAYER_MANGOHUD_overlay_${toString stdenv.hostPlatform.parsed.cpu.bits}"
    ''
    + ''
      # Add OpenGL driver and libXNVCtrl paths to RUNPATH to support NVIDIA cards
      addDriverRunpath "$out/lib/mangohud/libMangoHud.so"
      patchelf --add-rpath ${libXNVCtrl}/lib "$out/lib/mangohud/libMangoHud.so"
    ''
    + lib.optionalString gamescopeSupport ''
      addDriverRunpath "$out/bin/mangoapp"
    '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Vulkan and OpenGL overlay for monitoring FPS, temperatures, CPU/GPU load and more";
    homepage = "https://github.com/flightlessmango/MangoHud";
    changelog = "https://github.com/flightlessmango/MangoHud/releases/tag/v${finalAttrs.version}";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [
      kira-bruneau
      zeratax
    ];
  };
})

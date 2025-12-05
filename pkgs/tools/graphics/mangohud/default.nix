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
  libGL,
  libX11,
  hwdata,
  mangohud32,
  addDriverRunpath,
  appstream,
  glslang,
  python3Packages,
  meson,
  ninja,
  pkg-config,
  unzip,
  wayland,
  libXNVCtrl,
  spdlog,
  libxkbcommon,
  glfw,
  libXrandr,
  x11Support ? true,
  waylandSupport ? true,
  nvidiaSupport ? lib.meta.availableOn stdenv.hostPlatform libXNVCtrl,
  gamescopeSupport ? true,
  mangoappSupport ? gamescopeSupport,
  mangohudctlSupport ? gamescopeSupport,
  lowerBitnessSupport ? stdenv.hostPlatform.isx86_64, # Support 32 bit on 64bit
  nix-update-script,
}:

assert lib.assertMsg (
  x11Support || waylandSupport
) "either x11Support or waylandSupport should be enabled";

assert lib.assertMsg (nvidiaSupport -> x11Support) "nvidiaSupport requires x11Support";
assert lib.assertMsg (mangoappSupport -> x11Support) "mangoappSupport requires x11Support";

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
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "flightlessmango";
    repo = "MangoHud";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-BZ3R7D2zOlg69rx4y2FzzjpXuPOv913TOz9kSvRN+Wg=";
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
      libGL = libGL;
      libX11 = libX11;
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

  mesonFlags = [
    "-Duse_system_spdlog=enabled"
    "-Dtests=disabled" # amdgpu test segfaults in nix sandbox
    (lib.mesonEnable "with_x11" x11Support)
    (lib.mesonEnable "with_wayland" waylandSupport)
    (lib.mesonEnable "with_xnvctrl" nvidiaSupport)
    (lib.mesonBool "mangoapp" mangoappSupport)
    (lib.mesonBool "mangohudctl" mangohudctlSupport)
  ];

  strictDeps = true;

  nativeBuildInputs = [
    addDriverRunpath
    glslang
    python3Packages.mako
    meson
    ninja
    pkg-config
    unzip
  ];

  buildInputs = [
    dbus
    spdlog
  ]
  ++ lib.optional waylandSupport wayland
  ++ lib.optional x11Support libX11
  ++ lib.optional nvidiaSupport libXNVCtrl
  ++ lib.optional (x11Support || waylandSupport) libxkbcommon
  ++ lib.optionals mangoappSupport [
    glfw
    libXrandr
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
    + lib.optionalString nvidiaSupport ''
      # Add OpenGL driver and libXNVCtrl paths to RUNPATH to support NVIDIA cards
      addDriverRunpath "$out/lib/mangohud/libMangoHud.so"
      patchelf --add-rpath ${libXNVCtrl}/lib "$out/lib/mangohud/libMangoHud.so"
    ''
    + lib.optionalString mangoappSupport ''
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

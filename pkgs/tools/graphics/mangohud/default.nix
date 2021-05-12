{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, substituteAll
, coreutils
, curl
, gawk
, glxinfo
, gnugrep
, gnused
, pciutils
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
, vulkan-loader
, libXNVCtrl
}:

stdenv.mkDerivation rec {
  pname = "mangohud";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "flightlessmango";
    repo = "MangoHud";
    rev = "v${version}";
    sha256 = "1bzfp37qrx9kk5zaq7sfisgkyccwnxd7i3b1l0blfcy2lrxgx0n6";
    fetchSubmodules = true;
  };

  patches = [
    # Adds option to specify Vulkan's datadir when it's not the same as MangoHud's
    # See https://github.com/flightlessmango/MangoHud/pull/522
    (fetchpatch {
      url = "https://github.com/flightlessmango/MangoHud/commit/56682985d8cec711af7ad0841888a44099249b1b.patch";
      sha256 = "0l5vb374lfgfh54jiy4097bzsccpv4zsl1fdhn55sxggklymcad8";
    })

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
        pciutils
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

  mesonFlags = [
    "-Duse_system_vulkan=enabled"
    "-Dvulkan_datadir=${vulkan-headers}/share"
  ];

  nativeBuildInputs = [
    glslang
    makeWrapper
    meson
    ninja
    pkg-config
    python3Packages.Mako
    python3Packages.python
    vulkan-loader
  ];

  buildInputs = [
    dbus
    libX11
    libXNVCtrl
  ];

  # Support 32bit Vulkan applications by linking in 32bit Vulkan layer
  # This is needed for the same reason the 32bit OpenGL workaround is needed.
  postInstall = lib.optionalString (stdenv.hostPlatform.system == "x86_64-linux") ''
    ln -s ${mangohud32}/share/vulkan/implicit_layer.d/MangoHud.json \
      "$out/share/vulkan/implicit_layer.d/MangoHud.x86.json"
  '';

  # Support overlaying Vulkan applications without requiring mangohud to be installed
  postFixup = ''
    wrapProgram "$out/bin/mangohud" \
      --prefix VK_LAYER_PATH : "$out/share/vulkan/implicit_layer.d" \
      --prefix VK_INSTANCE_LAYERS : VK_LAYER_MANGOHUD_overlay
  '';

  meta = with lib; {
    description = "A Vulkan and OpenGL overlay for monitoring FPS, temperatures, CPU/GPU load and more";
    homepage = "https://github.com/flightlessmango/MangoHud";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ metadark zeratax ];
  };
}

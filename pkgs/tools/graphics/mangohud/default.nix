{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, meson
, ninja
, pkg-config
, python3Packages
, dbus
, glslang
, libglvnd
, libXNVCtrl
, mesa
, vulkan-headers
, vulkan-loader
, xorg
}:


stdenv.mkDerivation rec {
  pname = "mangohud${lib.optionalString stdenv.is32bit "_32"}";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "flightlessmango";
    repo = "MangoHud";
    rev = "v${version}";
    sha256 = "04v2ps8n15ph2smjgnssax5hq88bszw2kbcff37cnd5c8yysvfi6";
    fetchSubmodules = true;
  };

  patches = [
    (fetchpatch {
      # FIXME obsolete in >=0.5.0
      url = "https://patch-diff.githubusercontent.com/raw/flightlessmango/MangoHud/pull/208.patch";
      sha256 = "1i6x6sr4az1zv0p6vpw99n947c7awgbbv087fghjlczhry676nmh";
    })
  ];

  mesonFlags = [
    "-Dappend_libdir_mangohud=false"
    "-Duse_system_vulkan=enabled"
    "--libdir=lib${lib.optionalString stdenv.is32bit "32"}"
  ];

  buildInputs = [
    dbus
    glslang
    libglvnd
    libXNVCtrl
    mesa
    python3Packages.Mako
    vulkan-headers
    vulkan-loader
    xorg.libX11
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3Packages.Mako
    python3Packages.python
  ];

  preConfigure = ''
    mkdir -p "$out/share/vulkan/"
    ln -sf "${vulkan-headers}/share/vulkan/registry/" $out/share/vulkan/
    ln -sf "${vulkan-headers}/include" $out
  '';

  meta = with lib; {
    description = "A Vulkan and OpenGL overlay for monitoring FPS, temperatures, CPU/GPU load and more";
    homepage = "https://github.com/flightlessmango/MangoHud";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ zeratax ];
  };
}

{
  config,
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  cmake,

  # dependencies
  glib,
  libxfixes,
  libXinerama,
  catch2,
  gperf,

  # lib.optional features without extra dependencies
  mpdSupport ? true,
  ibmSupport ? true, # IBM/Lenovo notebooks

  # lib.optional features with extra dependencies

  docsSupport ? true,
  buildPackages,
  pandoc,
  python3,

  ncursesSupport ? true,
  ncurses ? null,
  x11Support ? true,
  freetype,
  xorg,
  waylandSupport ? true,
  pango,
  wayland,
  wayland-protocols,
  wayland-scanner,
  xdamageSupport ? x11Support,
  libXdamage ? null,
  doubleBufferSupport ? x11Support,
  imlib2Support ? x11Support,
  imlib2 ? null,

  luaSupport ? true,
  lua ? null,
  luaImlib2Support ? luaSupport && imlib2Support,
  luaCairoSupport ? luaSupport && (x11Support || waylandSupport),
  cairo ? null,
  toluapp ? null,

  wirelessSupport ? true,
  wirelesstools ? null,
  nvidiaSupport ? false,
  libXNVCtrl ? null,
  pulseSupport ? config.pulseaudio or false,
  libpulseaudio ? null,

  curlSupport ? true,
  curl ? null,
  rssSupport ? curlSupport,
  journalSupport ? true,
  systemd ? null,
  libxml2 ? null,

  extrasSupport ? true,

  versionCheckHook,
  expat,
}:

assert docsSupport -> pandoc != null && python3 != null;

assert ncursesSupport -> ncurses != null;

assert xdamageSupport -> x11Support && libXdamage != null;
assert imlib2Support -> x11Support && imlib2 != null;
assert luaSupport -> lua != null;
assert luaImlib2Support -> luaSupport && imlib2Support && toluapp != null;
assert luaCairoSupport -> luaSupport && toluapp != null && cairo != null;
assert luaCairoSupport || luaImlib2Support -> lua.luaversion == "5.4";

assert wirelessSupport -> wirelesstools != null;
assert nvidiaSupport -> libXNVCtrl != null;
assert pulseSupport -> libpulseaudio != null;

assert curlSupport -> curl != null;
assert rssSupport -> curlSupport && libxml2 != null;
assert journalSupport -> systemd != null;

assert extrasSupport -> python3 != null;

stdenv.mkDerivation (finalAttrs: {
  pname = "conky";
  version = "1.22.2";

  src = fetchFromGitHub {
    owner = "brndnmtthws";
    repo = "conky";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tMnfdW1sbZkt8v6DITM2R0ZwyN+xs7VLGZDityYt38Q=";
  };

  # pkg-config doesn't detect wayland-scanner in cross-compilation for some reason
  postPatch = ''
    substituteInPlace cmake/ConkyPlatformChecks.cmake \
      --replace-fail "pkg_get_variable(Wayland_SCANNER wayland-scanner wayland_scanner)" "set(Wayland_SCANNER ${lib.getExe buildPackages.wayland-scanner})"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    gperf
  ]
  ++ lib.optional docsSupport pandoc
  ++ lib.optional (docsSupport || extrasSupport) (
    # Use buildPackages to work around https://github.com/NixOS/nixpkgs/issues/305858
    buildPackages.python3.withPackages (ps: [
      ps.jinja2
      ps.pyyaml
    ])
  )
  ++ lib.optional luaImlib2Support toluapp
  ++ lib.optional luaCairoSupport toluapp;

  buildInputs = [
    glib
    libXinerama
  ]
  ++ lib.optional ncursesSupport ncurses
  ++ lib.optionals x11Support [
    freetype
    libxfixes
    xorg.libICE
    xorg.libX11
    xorg.libXext
    xorg.libXft
    xorg.libXfixes
    xorg.libSM
    expat
  ]
  ++ lib.optionals waylandSupport [
    pango
    wayland
    wayland-protocols
  ]
  ++ lib.optional xdamageSupport libXdamage
  ++ lib.optional imlib2Support imlib2
  ++ lib.optional luaSupport lua
  ++ lib.optional luaImlib2Support imlib2
  ++ lib.optional luaCairoSupport cairo
  ++ lib.optional wirelessSupport wirelesstools
  ++ lib.optional curlSupport curl
  ++ lib.optional rssSupport libxml2
  ++ lib.optional nvidiaSupport libXNVCtrl
  ++ lib.optional pulseSupport libpulseaudio
  ++ lib.optional journalSupport systemd;

  cmakeFlags = [
    (lib.cmakeBool "REPRODUCIBLE_BUILD" true)
    (lib.cmakeBool "RELEASE" true)
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "BUILD_EXTRAS" extrasSupport)
    (lib.cmakeBool "BUILD_DOCS" docsSupport)
    (lib.cmakeBool "BUILD_CURL" curlSupport)
    (lib.cmakeBool "BUILD_IBM" ibmSupport)
    (lib.cmakeBool "BUILD_IMLIB2" imlib2Support)
    (lib.cmakeBool "BUILD_LUA_CAIRO" luaCairoSupport)
    (lib.cmakeBool "BUILD_LUA_IMLIB2" luaImlib2Support)
    (lib.cmakeBool "BUILD_MPD" mpdSupport)
    (lib.cmakeBool "BUILD_NCURSES" ncursesSupport)
    (lib.cmakeBool "BUILD_RSS" rssSupport)
    (lib.cmakeBool "BUILD_X11" x11Support)
    (lib.cmakeBool "BUILD_WAYLAND" waylandSupport)
    (lib.cmakeBool "BUILD_XDAMAGE" xdamageSupport)
    (lib.cmakeBool "BUILD_XDBE" doubleBufferSupport)
    (lib.cmakeBool "BUILD_WLAN" wirelessSupport)
    (lib.cmakeBool "BUILD_NVIDIA" nvidiaSupport)
    (lib.cmakeBool "BUILD_PULSEAUDIO" pulseSupport)
    (lib.cmakeBool "BUILD_JOURNAL" journalSupport)
    (lib.cmakeFeature "CMAKE_INSTALL_DATAROOTDIR" "${placeholder "out"}/share")
  ];

  doCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    homepage = "https://conky.cc";
    changelog = "https://github.com/brndnmtthws/conky/releases/tag/${finalAttrs.src.tag}";
    description = "Advanced, highly configurable system monitor based on torsmo";
    mainProgram = "conky";
    maintainers = [ lib.maintainers.guibert ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})

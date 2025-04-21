{
  config,
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,

  # dependencies
  glib,
  libXinerama,
  catch2,
  gperf,

  # lib.optional features without extra dependencies
  mpdSupport ? true,
  ibmSupport ? true, # IBM/Lenovo notebooks

  # lib.optional features with extra dependencies

  docsSupport ? true,
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
  version = "1.22.1";

  src = fetchFromGitHub {
    owner = "brndnmtthws";
    repo = "conky";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tEJQWZBaiX/bONPZEuGcvbGidktcvxUZtLvcGjz71Lk=";
  };

  postPatch =
    lib.optionalString docsSupport ''
      substituteInPlace cmake/Conky.cmake --replace-fail "# set(RELEASE true)" "set(RELEASE true)"
    ''
    + lib.optionalString waylandSupport ''
      substituteInPlace src/CMakeLists.txt \
        --replace-fail 'COMMAND ''${Wayland_SCANNER}' 'COMMAND wayland-scanner'
    '';

  env = {
    # For some reason -Werror is on by default, causing the project to fail compilation.
    NIX_CFLAGS_COMPILE = "-Wno-error";
    NIX_LDFLAGS = "-lgcc_s";
  };

  nativeBuildInputs =
    [
      cmake
      pkg-config
    ]
    ++ lib.optional docsSupport pandoc
    ++ lib.optional (docsSupport || extrasSupport) (
      python3.withPackages (ps: [
        ps.jinja2
        ps.pyyaml
      ])
    )
    ++ lib.optional waylandSupport wayland-scanner
    ++ lib.optional luaImlib2Support toluapp
    ++ lib.optional luaCairoSupport toluapp;

  buildInputs =
    [
      glib
      libXinerama
      gperf
    ]
    ++ lib.optional ncursesSupport ncurses
    ++ lib.optionals x11Support [
      freetype
      xorg.libICE
      xorg.libX11
      xorg.libXext
      xorg.libXft
      xorg.libSM
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

  cmakeFlags =
    [
      "-DREPRODUCIBLE_BUILD=ON"
    ]
    ++ lib.optional (finalAttrs.doCheck) "-DBUILD_TESTING=ON"
    ++ lib.optional extrasSupport "-DBUILD_EXTRAS=ON"
    ++ lib.optional docsSupport "-DBUILD_DOCS=ON"
    ++ lib.optional curlSupport "-DBUILD_CURL=ON"
    ++ lib.optional (!ibmSupport) "-DBUILD_IBM=OFF"
    ++ lib.optional imlib2Support "-DBUILD_IMLIB2=ON"
    ++ lib.optional luaCairoSupport "-DBUILD_LUA_CAIRO=ON"
    ++ lib.optional luaImlib2Support "-DBUILD_LUA_IMLIB2=ON"
    ++ lib.optional (!mpdSupport) "-DBUILD_MPD=OFF"
    ++ lib.optional (!ncursesSupport) "-DBUILD_NCURSES=OFF"
    ++ lib.optional rssSupport "-DBUILD_RSS=ON"
    ++ lib.optional (!x11Support) "-DBUILD_X11=OFF"
    ++ lib.optional waylandSupport "-DBUILD_WAYLAND=ON"
    ++ lib.optional xdamageSupport "-DBUILD_XDAMAGE=ON"
    ++ lib.optional doubleBufferSupport "-DBUILD_XDBE=ON"
    ++ lib.optional wirelessSupport "-DBUILD_WLAN=ON"
    ++ lib.optional nvidiaSupport "-DBUILD_NVIDIA=ON"
    ++ lib.optional pulseSupport "-DBUILD_PULSEAUDIO=ON"
    ++ lib.optional journalSupport "-DBUILD_JOURNAL=ON";

  doCheck = true;

  meta = {
    homepage = "https://conky.cc";
    changelog = "https://github.com/brndnmtthws/conky/releases/tag/v${finalAttrs.version}";
    description = "Advanced, highly configurable system monitor based on torsmo";
    mainProgram = "conky";
    maintainers = [ lib.maintainers.guibert ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})

{
  lib,
  fetchFromGitHub,
  stdenv,
  autoreconfHook,
  pkg-config,
  ncurses,
  IOKit,
  libcap,
  libnl,
  sensorsSupport ? stdenv.hostPlatform.isLinux,
  lm_sensors,
  systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemd,
  systemd,
}:

assert systemdSupport -> stdenv.hostPlatform.isLinux;

stdenv.mkDerivation rec {
  pname = "htop";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "htop-dev";
    repo = pname;
    rev = version;
    hash = "sha256-4M2Kzy/tTpIZzpyubnXWywQh7Np5InT4sYkVG2v6wWs=";
  };

  # upstream removed pkg-config support and uses dlopen now
  postPatch =
    let
      libnlPath = lib.getLib libnl;
    in
    lib.optionalString stdenv.hostPlatform.isLinux ''
      substituteInPlace configure.ac \
        --replace-fail /usr/include/libnl3 ${lib.getDev libnl}/include/libnl3
      substituteInPlace linux/LibNl.c \
        --replace-fail libnl-3.so ${libnlPath}/lib/libnl-3.so \
        --replace-fail libnl-genl-3.so ${libnlPath}/lib/libnl-genl-3.so
    '';

  nativeBuildInputs = [ autoreconfHook ] ++ lib.optional stdenv.hostPlatform.isLinux pkg-config;

  buildInputs =
    [ ncurses ]
    ++ lib.optional stdenv.hostPlatform.isDarwin IOKit
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      libcap
      libnl
    ]
    ++ lib.optional sensorsSupport lm_sensors
    ++ lib.optional systemdSupport systemd;

  configureFlags =
    [
      "--enable-unicode"
      "--sysconfdir=/etc"
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      "--enable-affinity"
      "--enable-capabilities"
      "--enable-delayacct"
    ]
    ++ lib.optional sensorsSupport "--enable-sensors";

  postFixup =
    let
      optionalPatch = pred: so: lib.optionalString pred "patchelf --add-needed ${so} $out/bin/htop";
    in
    lib.optionalString (!stdenv.hostPlatform.isStatic) ''
      ${optionalPatch sensorsSupport "${lib.getLib lm_sensors}/lib/libsensors.so"}
      ${optionalPatch systemdSupport "${systemd}/lib/libsystemd.so"}
    '';

  meta = with lib; {
    description = "Interactive process viewer";
    homepage = "https://htop.dev";
    license = licenses.gpl2Only;
    platforms = platforms.all;
    maintainers = with maintainers; [
      rob
      relrod
      SuperSandro2000
    ];
    changelog = "https://github.com/htop-dev/htop/blob/${version}/ChangeLog";
    mainProgram = "htop";
  };
}

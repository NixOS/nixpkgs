{ lib, fetchFromGitHub, stdenv, autoreconfHook, pkg-config
, ncurses
, IOKit
, libcap
, libnl
, sensorsSupport ? stdenv.isLinux, lm_sensors
, systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemd, systemd
}:

assert systemdSupport -> stdenv.isLinux;

stdenv.mkDerivation rec {
  pname = "htop";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "htop-dev";
    repo = pname;
    rev = version;
    sha256 = "sha256-MwtsvdPHcUdegsYj9NGyded5XJQxXri1IM1j4gef1Xk=";
  };

  nativeBuildInputs = [ autoreconfHook ]
    ++ lib.optional stdenv.isLinux pkg-config
  ;

  buildInputs = [ ncurses ]
    ++ lib.optional stdenv.isDarwin IOKit
    ++ lib.optionals stdenv.isLinux [ libcap libnl ]
    ++ lib.optional sensorsSupport lm_sensors
    ++ lib.optional systemdSupport systemd
  ;

  configureFlags = [ "--enable-unicode" "--sysconfdir=/etc" ]
    ++ lib.optionals stdenv.isLinux [
      "--enable-affinity"
      "--enable-capabilities"
      "--enable-delayacct"
    ]
    ++ lib.optional sensorsSupport "--with-sensors"
  ;

  postFixup =
    let
      optionalPatch = pred: so: lib.optionalString pred "patchelf --add-needed ${so} $out/bin/htop";
    in lib.optionalString (!stdenv.hostPlatform.isStatic) ''
      ${optionalPatch sensorsSupport "${lm_sensors}/lib/libsensors.so"}
      ${optionalPatch systemdSupport "${systemd}/lib/libsystemd.so"}
    '';

  meta = with lib; {
    description = "An interactive process viewer";
    homepage = "https://htop.dev";
    license = licenses.gpl2Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ rob relrod SuperSandro2000 ];
    changelog = "https://github.com/htop-dev/htop/blob/${version}/ChangeLog";
  };
}

{ lib, fetchFromGitHub, stdenv, autoreconfHook
, ncurses
, IOKit
, sensorsSupport ? stdenv.isLinux, lm_sensors
, systemdSupport ? stdenv.isLinux, systemd
}:

with lib;

assert systemdSupport -> stdenv.isLinux;

stdenv.mkDerivation rec {
  pname = "htop";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "htop-dev";
    repo = pname;
    rev = version;
    sha256 = "sha256-/48Ca7JPzhPS4eYsPbwbSVcx9aS1f0LHcqsbNVWL+9k=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ ncurses ]
    ++ optional stdenv.isDarwin IOKit
    ++ optional sensorsSupport lm_sensors
    ++ optional systemdSupport systemd
  ;

  configureFlags = [ "--enable-unicode" ]
    ++ optional sensorsSupport "--with-sensors"
  ;

  postFixup =
    let
      optionalPatch = pred: so: optionalString pred "patchelf --add-needed ${so} $out/bin/htop";
    in
    ''
      ${optionalPatch sensorsSupport "${lm_sensors}/lib/libsensors.so"}
      ${optionalPatch systemdSupport "${systemd}/lib/libsystemd.so"}
    '';

  meta = {
    description = "An interactive process viewer for Linux";
    homepage = "https://htop.dev";
    license = licenses.gpl2Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ rob relrod ];
    changelog = "https://github.com/htop-dev/${pname}/blob/${version}/ChangeLog";
  };
}

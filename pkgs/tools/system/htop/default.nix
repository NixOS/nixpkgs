{ lib, fetchFromGitHub, stdenv, autoreconfHook
, ncurses
, IOKit
, sensorsSupport ? stdenv.isLinux, lm_sensors
, systemdSupport ? stdenv.isLinux, systemd
}:

assert systemdSupport -> stdenv.isLinux;

stdenv.mkDerivation rec {
  pname = "htop";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "htop-dev";
    repo = pname;
    rev = version;
    sha256 = "sha256-p/lc7G/XFllulXrM47mPE6W5vVuoi4uXB8To36PIgZo=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ ncurses ]
    ++ lib.optional stdenv.isDarwin IOKit
    ++ lib.optional sensorsSupport lm_sensors
    ++ lib.optional systemdSupport systemd
  ;

  configureFlags = [ "--enable-unicode" "--sysconfdir=/etc" ]
    ++ lib.optional sensorsSupport "--with-sensors"
  ;

  postFixup =
    let
      optionalPatch = pred: so: lib.optionalString pred "patchelf --add-needed ${so} $out/bin/htop";
    in
    ''
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

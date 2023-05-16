{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, curl
, dbus
, libevent
, m4
, meson
, ninja
, pkg-config
, scdoc
, json_c
, xdg-utils
}:

stdenv.mkDerivation rec {
  pname = "mpris-scrobbler";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "mariusor";
    repo = "mpris-scrobbler";
    rev = "v${version}";
    sha256 = "sha256-HUEUkVL5d6FD698k8iSCJMNeSo8vGJCsExJW/E0EWpQ=";
  };

  postPatch = ''
    substituteInPlace src/signon.c \
      --replace "/usr/bin/xdg-open" "${xdg-utils}/bin/xdg-open"
  '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace meson.build \
      --replace "-Werror=format-truncation=0" "" \
      --replace "-Wno-stringop-overflow" ""
  '';

  nativeBuildInputs = [
    m4
    meson
    ninja
    pkg-config
    scdoc
  ];

  buildInputs = [
    curl
    dbus
    json_c
    libevent
  ];

  mesonFlags = [
    "-Dversion=${version}"
  ];

  env.NIX_CFLAGS_COMPILE = toString ([
    # Needed with GCC 12
    "-Wno-error=address"
  ] ++ lib.optionals stdenv.isDarwin [
    "-Wno-sometimes-uninitialized"
    "-Wno-tautological-pointer-compare"
  ] ++ lib.optionals stdenv.isLinux [
    "-Wno-array-bounds"
    "-Wno-free-nonheap-object"
    "-Wno-stringop-truncation"
  ]);

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
<<<<<<< HEAD
    description = "Minimalistic scrobbler for ListenBrainz, libre.fm, & last.fm";
=======
    description = "Minimalistic scrobbler for libre.fm & last.fm";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    homepage = "https://github.com/mariusor/mpris-scrobbler";
    license = licenses.mit;
    maintainers = with maintainers; [ emantor ];
    platforms = platforms.unix;
  };
}

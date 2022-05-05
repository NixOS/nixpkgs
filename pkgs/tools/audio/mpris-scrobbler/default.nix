{ lib, stdenv
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
  version = "0.4.90";

  src = fetchFromGitHub {
    owner  = "mariusor";
    repo   = "mpris-scrobbler";
    rev    = "v${version}";
    sha256 = "sha256-+Y5d7yFOnSk2gQS/m/01ofbNeDCLXb+cTTlHj4bgO0M=";
  };

  postPatch = ''
    substituteInPlace src/signon.c \
      --replace "/usr/bin/xdg-open" "${xdg-utils}/bin/xdg-open"
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

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with lib; {
    description = "Minimalistic scrobbler for libre.fm & last.fm";
    homepage = "https://github.com/mariusor/mpris-scrobbler";
    license = licenses.mit;
    maintainers = with maintainers; [ emantor ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/mpris-scrobbler.x86_64-darwin
  };
}

{ stdenv
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
, xdg_utils
}:

stdenv.mkDerivation rec {
  pname = "mpris-scrobbler";
  version = "0.4.0.1";

  src = fetchFromGitHub {
    owner  = "mariusor";
    repo   = "mpris-scrobbler";
    rev    = "v${version}";
    sha256 = "0jzmgcb9a19hl8y7iwy8l3cc2vgzi0scw7r5q72kszfyxn0yk2gs";
  };

  postPatch = ''
    substituteInPlace src/signon.c \
      --replace "/usr/bin/xdg-open" "${xdg_utils}/bin/xdg-open"
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

  meta = with stdenv.lib; {
    description = "Minimalistic scrobbler for libre.fm & last.fm";
    homepage    = "https://github.com/mariusor/mpris-scrobbler";
    license     = licenses.mit;
    maintainers = with maintainers; [ emantor ];
    platforms   = platforms.unix;
  };
}

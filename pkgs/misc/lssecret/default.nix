{ lib
, stdenv
, fetchFromGitLab
, pkg-config
, libsecret
}:

stdenv.mkDerivation rec {
  name = "lssecret";
  version = "unstable-2022-12-02";

  src = fetchFromGitLab {
    owner = "GrantMoyer";
    repo = name;
    rev = "20fd771a";
    hash = "sha256-yU70WZj4EC/sFJxyq2SQ0YQ6RCQHYiW/aQiYWo7+ujk=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libsecret ];

  makeFlags = ["DESTDIR=$(out)"];

  meta = {
    description = "A tool to list passwords and other secrets stored using the org.freedesktop.secrets dbus api";
    homepage = "https://gitlab.com/GrantMoyer/lssecret";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ genericnerdyusername ];
    platforms = lib.platforms.unix;
  };
}

{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, asciidoc
, jansson
, jose
, http-parser
, systemd
, meson
, ninja
}:

stdenv.mkDerivation rec {
  pname = "tang";
  version = "13";

  src = fetchFromGitHub {
    owner = "latchset";
    repo = "tang";
    rev = "refs/tags/v${version}";
    hash = "sha256-SOdgMUWavTaDUiVvpEyE9ac+9aDmZs74n7ObugksBcc=";
  };

  nativeBuildInputs = [
    asciidoc
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    jansson
    jose
    http-parser
    systemd
  ];

  outputs = [
    "out"
    "man"
  ];

  meta = {
    description = "Server for binding data to network presence";
    homepage = "https://github.com/latchset/tang";
    changelog = "https://github.com/latchset/tang/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ fpletz ];
    license = lib.licenses.gpl3Plus;
  };
}

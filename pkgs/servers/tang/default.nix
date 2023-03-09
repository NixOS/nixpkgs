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
  version = "12";

  src = fetchFromGitHub {
    owner = "latchset";
    repo = "tang";
    rev = "refs/tags/v${version}";
    hash = "sha256-wfZFOJrVzjtysh0VKdw5O+DJybYkV9bYJNnaku6YctE=";
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

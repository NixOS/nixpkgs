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
, makeWrapper
, testers
, tang
, gitUpdater
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "tang";
  version = "14";

  src = fetchFromGitHub {
    owner = "latchset";
    repo = "tang";
    rev = "refs/tags/v${version}";
    hash = "sha256-QKURKb2g71pZvuZlJk3Rc26H3oU0WSkjgQtJQLrYGbw=";
  };

  nativeBuildInputs = [
    asciidoc
    meson
    ninja
    pkg-config
    makeWrapper
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

  postFixup = ''
    wrapProgram $out/bin/tang-show-keys --prefix PATH ":" ${lib.makeBinPath [ jose ]}
    wrapProgram $out/libexec/tangd-keygen --prefix PATH ":" ${lib.makeBinPath [ jose ]}
    wrapProgram $out/libexec/tangd-rotate-keys --prefix PATH ":" ${lib.makeBinPath [ jose ]}
  '';

  passthru = {
    tests = {
      inherit (nixosTests) tang;
      version = testers.testVersion {
        package = tang;
        command = "${tang}/libexec/tangd --version";
        version = "tangd ${version}";
      };
    };
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Server for binding data to network presence";
    homepage = "https://github.com/latchset/tang";
    changelog = "https://github.com/latchset/tang/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ fpletz ];
    license = lib.licenses.gpl3Plus;
    mainProgram = "tangd";
  };
}

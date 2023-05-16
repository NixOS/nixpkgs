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
<<<<<<< HEAD
, makeWrapper
, testers
, tang
, gitUpdater
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "tang";
<<<<<<< HEAD
  version = "14";
=======
  version = "13";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "latchset";
    repo = "tang";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-QKURKb2g71pZvuZlJk3Rc26H3oU0WSkjgQtJQLrYGbw=";
=======
    hash = "sha256-SOdgMUWavTaDUiVvpEyE9ac+9aDmZs74n7ObugksBcc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    asciidoc
    meson
    ninja
    pkg-config
<<<<<<< HEAD
    makeWrapper
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  postFixup = ''
    wrapProgram $out/bin/tang-show-keys --prefix PATH ":" ${lib.makeBinPath [ jose ]}
    wrapProgram $out/libexec/tangd-keygen --prefix PATH ":" ${lib.makeBinPath [ jose ]}
    wrapProgram $out/libexec/tangd-rotate-keys --prefix PATH ":" ${lib.makeBinPath [ jose ]}
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = tang;
      command = "${tang}/libexec/tangd --version";
      version = "tangd ${version}";
    };
    updateScript = gitUpdater { };
  };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = {
    description = "Server for binding data to network presence";
    homepage = "https://github.com/latchset/tang";
    changelog = "https://github.com/latchset/tang/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ fpletz ];
    license = lib.licenses.gpl3Plus;
  };
}

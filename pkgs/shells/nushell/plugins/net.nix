{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, IOKit
, CoreFoundation
, unstableGitUpdater
}:

rustPlatform.buildRustPackage {
  pname = "nu-plugin-net";
  version = "unstable-2023-11-15";

  src = fetchFromGitHub {
    owner = "fennewald";
    repo = "nu_plugin_net";
    rev = "20a0a18be0e11650f453d6f186d99d3691a1cd6a";
    hash = "sha256-GHUis38mz9sI5s+E/eLyA0XPyuNpPoS1TyhU3pMEsvs=";
  };

  cargoHash = "sha256-T5kUVtJty8pfPihtkJqCgF3AUFcBuu2cwX4cVGM8n5U=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreFoundation
    IOKit
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "A nushell plugin to list system network interfaces";
    homepage = "https://github.com/fennewald/nu_plugin_net";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
    mainProgram = "nu-plugin-net";
  };
}

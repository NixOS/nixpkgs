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
  version = "unstable-2024-04-05";

  src = fetchFromGitHub {
    owner = "fennewald";
    repo = "nu_plugin_net";
    rev = "a84d72290f513397a359581b9447a4e638ce60c9";
    hash = "sha256-uKLYTRR2tThSvwWbvEePOLZ9ehNPfCYruZxTKSIxpEA=";
  };

  cargoHash = "sha256-2A9RalZhXigLq/6w738G6PnkV3FyK+3HHXPDQRHTIm0=";

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

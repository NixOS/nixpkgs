{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, IOKit
, CoreFoundation
, nix-update-script
}:

rustPlatform.buildRustPackage {
  pname = "nu-plugin-net";
  version = "unstable-2023-09-27";

  src = fetchFromGitHub {
    owner = "fennewald";
    repo = "nu_plugin_net";
    rev = "1761ed3d7f68925f1234316bd62c91d1d9d7cb4d";
    hash = "sha256-ZEktfN/zg/VIiBGq/o0T05tLViML2TzfuLw0qliPQg8=";
  };

  cargoHash = "sha256-bRw9V75VnOL1n2jPs6QI/A3pik00pGiA9ZzQk1F1JRI=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreFoundation
    IOKit
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "A nushell plugin to list system network interfaces";
    homepage = "https://github.com/fennewald/nu_plugin_net";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
    mainProgram = "nu-plugin-net";
  };
}

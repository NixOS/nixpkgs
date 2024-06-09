{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  IOKit,
  CoreFoundation,
  unstableGitUpdater,
}:

rustPlatform.buildRustPackage {
  pname = "nu-plugin-net";
  version = "0-unstable-2024-04-05";

  src = fetchFromGitHub {
    owner = "fennewald";
    repo = "nu_plugin_net";
    rev = "60d315afb19c3c673409db796a4cc7a240058605";
    hash = "sha256-izIxV2rFxZ1Om6NNaofNpc5prtN/lsw8dC4DyKEQ+v8=";
  };

  cargoHash = "sha256-nBxcxADyvPgGrfkW8eBq/wmB2Slq+YGJV2IlxuuCgCg=";

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

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
    mainProgram = "nu_plugin_net";
  };
}

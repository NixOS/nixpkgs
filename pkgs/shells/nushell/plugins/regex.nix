{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
, IOKit
}:

rustPlatform.buildRustPackage {
  pname = "nushell_plugin_regex";
  version = "unstable-2023-10-08";

  src = fetchFromGitHub {
    owner = "fdncred";
    repo = "nu_plugin_regex";
    rev = "e1aa88e703f1f632ede685dd733472d34dd0c8e7";
    hash = "sha256-GJgnsaeNDJoJjw8RPw6wpEq1mIult18Eh4frl8Plgxc=";
  };

  cargoHash = "sha256-AACpzSavY6MlYnl1lDYxVlfsEvEpNK0u8SzsoSZbqFc=";

  buildInputs = lib.optionals stdenv.isDarwin [ IOKit ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "A Nushell plugin to parse regular expressions";
    homepage = "https://github.com/fdncred/nu_plugin_regex";
    license = licenses.mit;
    maintainers = with maintainers; [ aidalgol ];
    platforms = with platforms; all;
  };
}

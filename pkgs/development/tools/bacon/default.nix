{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, CoreServices
}:

rustPlatform.buildRustPackage rec {
  pname = "bacon";
  version = "2.13.0";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-KFBb5poogtFnYePu9E5XBE0sKKev2Fuxaqj5ypscuqA=";
  };

  cargoHash = "sha256-OA8068ISy2WoC34Q0ANrWX27ESErntCfZ5IrO8Lvm10=";

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreServices
  ];

  meta = with lib; {
    description = "Background rust code checker";
    homepage = "https://github.com/Canop/bacon";
    changelog = "https://github.com/Canop/bacon/blob/v${version}/CHANGELOG.md";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ FlorianFranzen ];
  };
}

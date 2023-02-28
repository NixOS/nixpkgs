{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, CoreServices
}:

rustPlatform.buildRustPackage rec {
  pname = "bacon";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-NszXIVgK65gTsiEmOaw3cMaR0A+ojNYa08ETJ6dP+4c=";
  };

  cargoHash = "sha256-ssrZ6v5euf8AgAdvsjYt6L+dxrIBYoaiHxvBQN2KE+8=";

  buildInputs = lib.optional stdenv.isDarwin [
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

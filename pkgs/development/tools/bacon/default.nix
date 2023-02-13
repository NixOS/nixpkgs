{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, CoreServices
}:

rustPlatform.buildRustPackage rec {
  pname = "bacon";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-k87EgsH7EdnqYBoXHpPu7hB/goEXuZsz8mNsrvM+Hgw=";
  };

  cargoHash = "sha256-ujc3tH9I2WqwxmqBaUdE8lJQtj7XS56IVaxfZWhmvF8=";

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

{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, CoreServices
}:

rustPlatform.buildRustPackage rec {
  pname = "bacon";
  version = "2.6.3";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-EmkPH0TjLa9ouRjgv0IEyhqx5VaHR2TUQdqznKIKZdY=";
  };

  cargoHash = "sha256-vEged6GfcdcibCm4JX4/GIo1qbVtT+jX721+iLKOQsc=";

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

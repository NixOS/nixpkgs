{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  CoreServices,
}:

rustPlatform.buildRustPackage rec {
  pname = "bacon";
  version = "2.18.0";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Lwmp6csNX0oYk2JOo3fojyjYpOSZg4ev8aZmkEzzAKA=";
  };

  cargoHash = "sha256-WxrdeE3x/WAHpJBsPsIP+qzxRkinVc8IyLZ75GwB1/g=";

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreServices
  ];

  meta = with lib; {
    description = "Background rust code checker";
    mainProgram = "bacon";
    homepage = "https://github.com/Canop/bacon";
    changelog = "https://github.com/Canop/bacon/blob/v${version}/CHANGELOG.md";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ FlorianFranzen ];
  };
}

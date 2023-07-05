{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, CoreServices
}:

rustPlatform.buildRustPackage rec {
  pname = "bacon";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-7eRLv1ZrD3eVGoR0lmtefpW7NlokF+4vuleiT8BzCc8=";
  };

  cargoHash = "sha256-jETjBGIwNh2Jt6aNNrOF+JOwGHKWIpMEacPp6zjbIhU=";

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

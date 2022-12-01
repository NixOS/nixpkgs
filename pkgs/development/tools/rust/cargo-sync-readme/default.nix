{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-sync-readme";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "phaazon";
    repo = pname;
    rev = version;
    sha256 = "sha256-n9oIWblTTuXFFQFN6mpQiCH5N7yg5fAp8v9vpB5/DAo=";
  };

  cargoSha256 = "sha256-DsB2C2ELuvuVSvxG/xztmnY2qfX8+Y7udbXlpRQoL/c=";

  meta = with lib; {
    description = "A cargo plugin that generates a Markdown section in your README based on your Rust documentation";
    homepage = "https://github.com/phaazon/cargo-sync-readme";
    changelog = "https://github.com/phaazon/cargo-sync-readme/blob/${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ b4dm4n ];
  };
}

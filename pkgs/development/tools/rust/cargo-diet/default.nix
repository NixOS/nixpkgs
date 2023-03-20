{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-diet";
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "the-lean-crate";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JzhSTbEf2Yl5cEIb+88y+s8lUN6c1Mir4NYvzAWMZwY=";
  };

  cargoSha256 = "sha256-zW6ec8DHzP6AuNI6fcOQLH03ca+/yjdh56nltSM9pAA=";

  meta = with lib; {
    description = "Help computing optimal include directives for your Cargo.toml manifest";
    homepage = "https://github.com/the-lean-crate/cargo-diet";
    changelog = "https://github.com/the-lean-crate/cargo-diet/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}

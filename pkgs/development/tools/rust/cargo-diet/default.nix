{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-diet";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "the-lean-crate";
    repo = pname;
    rev = "v${version}";
    sha256 = "1wxwf3i8qhak8b61iscsbndm4z7r5sg6iiarqlpf0y3lzb0yi5ah";
  };

  cargoSha256 = "06scamzr1676q5lx75bm05hdr21mdiby84dpm1wf2va5qpq6mjyl";

  meta = with lib; {
    description = "Help computing optimal include directives for your Cargo.toml manifest";
    homepage = "https://github.com/the-lean-crate/cargo-diet";
    changelog = "https://github.com/the-lean-crate/cargo-diet/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}

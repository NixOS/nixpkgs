{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-insta";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "mitsuhiko";
    repo = "insta";
    rev = version;
    sha256 = "1lcbdzh139lhmpz3pyik8nbgrbfc42z9ydz2hkg2lzjdpfdsz3ag";
  };

  cargoPatches = [ ./cargo-lock.patch ];
  cargoSha256 = "0sxlgy225x8bn48r9jidaw6r00hclvrj2p4prcx802094dhcwknk";

  patches = [ ./ignore-rustfmt-test.patch ];

  cargoBuildFlags = [ "-p cargo-insta" ];

  meta = with lib; {
    description = "A Cargo subcommand for snapshot testing";
    homepage = "https://github.com/mitsuhiko/insta";
    license = licenses.asl20;
    maintainers = with lib.maintainers; [ oxalica ];
  };
}

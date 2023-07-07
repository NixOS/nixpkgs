{ lib
, rustPlatform
, fetchCrate
, pkg-config
, openssl
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-audit";
  version = "0.17.6";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-ICNcBqlkX1k3J5vc/bfoXw/+l2LdHOchv4PfY0G7Y94=";
  };

  cargoSha256 = "sha256-ViqaiSLVfDJhMuHjHGi+NVRLPcRhe2a+oKXl4UNM+K8=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  buildFeatures = [ "fix" ];

  # The tests require network access which is not available in sandboxed Nix builds.
  doCheck = false;

  meta = with lib; {
    description = "Audit Cargo.lock files for crates with security vulnerabilities";
    homepage = "https://rustsec.org";
    changelog = "https://github.com/rustsec/rustsec/blob/cargo-audit/${version}/cargo-audit/CHANGELOG.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ basvandijk figsoda jk ];
  };
}

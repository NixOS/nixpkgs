{ lib
, rustPlatform
, fetchCrate
, pkg-config
<<<<<<< HEAD
, libgit2_1_5
, openssl
, zlib
=======
, openssl
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-audit";
<<<<<<< HEAD
  version = "0.18.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-XK2SsyT4CyDjCF56v/g7tX5SZKC3krBQNs/ddeFu35A=";
  };

  cargoHash = "sha256-1Uifk1W7NCmHAbUl83GpMUBD6WWUl1J/HjtGv4dEuiA=";
=======
  version = "0.17.6";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-ICNcBqlkX1k3J5vc/bfoXw/+l2LdHOchv4PfY0G7Y94=";
  };

  cargoSha256 = "sha256-ViqaiSLVfDJhMuHjHGi+NVRLPcRhe2a+oKXl4UNM+K8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
<<<<<<< HEAD
    libgit2_1_5
    openssl
    zlib
=======
    openssl
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  buildFeatures = [ "fix" ];

  # The tests require network access which is not available in sandboxed Nix builds.
  doCheck = false;

  meta = with lib; {
    description = "Audit Cargo.lock files for crates with security vulnerabilities";
    homepage = "https://rustsec.org";
<<<<<<< HEAD
    changelog = "https://github.com/rustsec/rustsec/blob/cargo-audit/v${version}/cargo-audit/CHANGELOG.md";
=======
    changelog = "https://github.com/rustsec/rustsec/blob/cargo-audit/${version}/cargo-audit/CHANGELOG.md";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ basvandijk figsoda jk ];
  };
}

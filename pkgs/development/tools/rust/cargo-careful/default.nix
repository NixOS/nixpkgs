{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {

  pname = "cargo-careful";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "RalfJung";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-kKF/Fp6RCF9PUdgqeo2e4vLVhl8+5M4oa0Q18ZdXJRc=";
  };

  cargoSha256 = "sha256-rhTi4rHfU+ZgNAMXSX7r5k3NfMUPNjHIUDs6FzeqcWk=";

  meta = with lib; {
    description = "A cargo undefined behaviour checker";
    homepage = "https://github.com/RalfJung/cargo-careful";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ DieracDelta ];
  };

}

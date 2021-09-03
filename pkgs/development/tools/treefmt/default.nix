{ lib, rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
  pname = "treefmt";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "numtide";
    repo = "treefmt";
    rev = "v${version}";
    sha256 = "0h9xl887620d0b4y17nhkayr0raj8b7m6zsgx8gw4v9vdjkjbbpa";
  };

  cargoSha256 = "04zmc2vaxsm4f1baissv3a6hnji3raixg891m3m8l13vin1a884q";

  meta = {
    description = "one CLI to format the code tree";
    homepage = "https://github.com/numtide/treefmt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zimbatm ];
  };
}

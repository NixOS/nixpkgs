{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-llvm-lines";
  version = "0.4.13";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    sha256 = "sha256-sN0i2oo0XuxneIK/w+jpxkcdm2rtqhyH2Y3CMPnH+ro=";
  };

  cargoSha256 = "sha256-Gv7C4NFThNawhT+IYO0ZbpOh6w/yPeIJKZjzTyM/GJw=";

  meta = with lib; {
    description = "Count the number of lines of LLVM IR across all instantiations of a generic function";
    homepage = "https://github.com/dtolnay/cargo-llvm-lines";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}

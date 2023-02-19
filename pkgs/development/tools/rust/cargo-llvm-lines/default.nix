{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-llvm-lines";
  version = "0.4.24";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    sha256 = "sha256-+jCjbx3CytE7wpVmErJjGFZS7E8VB8wjl7BAd9/USuY=";
  };

  cargoSha256 = "sha256-QC4+hXJiDB0odGm0/m0/JpQv5TyaAg4MmU/0vMJytk4=";

  meta = with lib; {
    description = "Count the number of lines of LLVM IR across all instantiations of a generic function";
    homepage = "https://github.com/dtolnay/cargo-llvm-lines";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}

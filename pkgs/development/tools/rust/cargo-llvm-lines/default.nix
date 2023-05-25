{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-llvm-lines";
  version = "0.4.29";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    hash = "sha256-8FpNUCOK0vAyO7f1Uy+BaqDcZ0GEFvp7meULHtUncNA=";
  };

  cargoHash = "sha256-uIB+fMSVZGZ7OTgiTEeozjPR6CuMsLgEbq/9//of6xo=";

  meta = with lib; {
    description = "Count the number of lines of LLVM IR across all instantiations of a generic function";
    homepage = "https://github.com/dtolnay/cargo-llvm-lines";
    changelog = "https://github.com/dtolnay/cargo-llvm-lines/releases/tag/${src.rev}";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}

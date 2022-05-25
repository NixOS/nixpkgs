{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-llvm-lines";
  version = "0.4.15";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    sha256 = "sha256-pP1kMwxIrL2ADvj4AkbhqKH5vzGyQnfL7hjg3/QYIY8=";
  };

  cargoSha256 = "sha256-V9mD9NAG7bB8uB/pjl0XGXmJqOUm4ZrFJV7nv569XOM=";

  meta = with lib; {
    description = "Count the number of lines of LLVM IR across all instantiations of a generic function";
    homepage = "https://github.com/dtolnay/cargo-llvm-lines";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}

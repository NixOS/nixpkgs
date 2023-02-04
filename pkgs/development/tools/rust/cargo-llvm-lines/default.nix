{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-llvm-lines";
  version = "0.4.23";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    sha256 = "sha256-u3MvDiagCGD7WjagbVF+TtZ0ATe8WBT3xeyduxrXPi4=";
  };

  cargoSha256 = "sha256-9oBnETZqJV35FEw6NImy6cqfVOVE5EHPNVGajE2UT10=";

  meta = with lib; {
    description = "Count the number of lines of LLVM IR across all instantiations of a generic function";
    homepage = "https://github.com/dtolnay/cargo-llvm-lines";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}

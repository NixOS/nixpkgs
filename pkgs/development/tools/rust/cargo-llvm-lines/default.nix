{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-llvm-lines";
  version = "0.4.16";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    sha256 = "sha256-MDRVNCfyObEaN0eNnaDBQCYQV2Y1Ck5/8zdpG4eZbaE=";
  };

  cargoSha256 = "sha256-oOUidCM3Xex8bqBVJmrigHZHMdjXBNDdKaPiA/+MR7s=";

  meta = with lib; {
    description = "Count the number of lines of LLVM IR across all instantiations of a generic function";
    homepage = "https://github.com/dtolnay/cargo-llvm-lines";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}

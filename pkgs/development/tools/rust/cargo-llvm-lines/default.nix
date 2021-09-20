{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-llvm-lines";
  version = "0.4.11";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    sha256 = "1p1agxsarkhw1mlqxawb2pj0fvsdyvi1rpp11p2k7fm341z1j71p";
  };

  cargoSha256 = "1b5py9md3lkqjyn9jkl6bdynfri0yvqvrfj2frbps0hqbxiv30jl";

  meta = with lib; {
    description = "Count the number of lines of LLVM IR across all instantiations of a generic function";
    homepage = "https://github.com/dtolnay/cargo-llvm-lines";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}

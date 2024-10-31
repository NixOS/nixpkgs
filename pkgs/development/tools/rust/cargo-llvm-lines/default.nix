{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-llvm-lines";
  version = "0.4.40";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    hash = "sha256-FyPq2+Smx4ZbJG13TKUHlyAANU4JbpAAUxisH9c4Aq8=";
  };

  cargoHash = "sha256-AH27+WrWguFpZFIq3N8Wb1Nlwbof6tgX0W4AtwMtoVw=";

  meta = with lib; {
    description = "Count the number of lines of LLVM IR across all instantiations of a generic function";
    mainProgram = "cargo-llvm-lines";
    homepage = "https://github.com/dtolnay/cargo-llvm-lines";
    changelog = "https://github.com/dtolnay/cargo-llvm-lines/releases/tag/${src.rev}";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
  };
}

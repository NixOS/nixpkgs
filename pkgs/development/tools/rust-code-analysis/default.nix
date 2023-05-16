<<<<<<< HEAD
{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "rust-code-analysis";
  version = "0.0.25";

  src = fetchCrate {
    pname = "rust-code-analysis-cli";
    inherit version;
    hash = "sha256-/Irmtsy1PdRWQ7dTAHLZJ9M0J7oi2IiJyW6HeTIDOCs=";
  };

  cargoHash = "sha256-axrtFZQOm1/UUBq1CDFkaZCks1mWoLWmfajDfsqSBmY=";
=======
{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "rust-code-analysis";
  version = "0.0.23";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = pname;
    rev = "v${version}";
    sha256 = "1l9qr5rvbj542fx6g6h9p38z31kvwli39vipbmd3pvic2mpi6mzx";
  };

  cargoSha256 = "sha256-++d/czDJVGzY8GvBpBKpP0Rum4J4RpT95S81IRUWY2M=";

  cargoBuildFlags = [ "--workspace" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Analyze and collect metrics on source code";
    homepage = "https://github.com/mozilla/rust-code-analysis";
    license = with licenses; [
      mit # grammars
      mpl20 # code
    ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "rust-code-analysis-cli";
  };
}

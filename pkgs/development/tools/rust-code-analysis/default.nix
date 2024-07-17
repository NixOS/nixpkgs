{
  lib,
  rustPlatform,
  fetchCrate,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "rust-code-analysis";
  version = "0.0.25";

  src = fetchCrate {
    pname = "rust-code-analysis-cli";
    inherit version;
    hash = "sha256-/Irmtsy1PdRWQ7dTAHLZJ9M0J7oi2IiJyW6HeTIDOCs=";
  };

  cargoHash = "sha256-axrtFZQOm1/UUBq1CDFkaZCks1mWoLWmfajDfsqSBmY=";

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

{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-vet";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HSEhFCcdC79OA8MP73De+iLIjcr1XMHxfJ9a1Q3JJYI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-+X6DLxWPWMcGzJMVZAj3C5P5MyywIb4ml0Jsyo9/uAE=";

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin Security;

  # the test_project tests require internet access
  checkFlags = [
    "--skip=test_project"
  ];

  meta = with lib; {
    description = "Tool to help projects ensure that third-party Rust dependencies have been audited by a trusted source";
    mainProgram = "cargo-vet";
    homepage = "https://mozilla.github.io/cargo-vet";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [
      figsoda
      jk
      matthiasbeyer
    ];
  };
}

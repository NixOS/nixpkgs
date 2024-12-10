{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-vet";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = pname;
    rev = version;
    sha256 = "sha256-VnOqQ1dKgNZSHTzJrD7stoCzNGrSkYxcLDJAsrJUsEQ=";
  };

  cargoSha256 = "sha256-M8sZzgSEMIB6pPVaE+tC18MCbwYaYpHOnhrEvm9JTso=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  # the test_project tests require internet access
  checkFlags = [
    "--skip=test_project"
  ];

  meta = with lib; {
    description = "A tool to help projects ensure that third-party Rust dependencies have been audited by a trusted source";
    mainProgram = "cargo-vet";
    homepage = "https://mozilla.github.io/cargo-vet";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [
      figsoda
      jk
    ];
  };
}

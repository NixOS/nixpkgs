{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "evtx";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "omerbenamram";
    repo = "evtx";
    rev = "refs/tags/v${version}";
    hash = "sha256-q2IpWWL/wmjVKSwupAa43zpXF+8/a1Cm/lKOmpwcsLA=";
  };

  cargoHash = "sha256-O6XnBvLLoTvYA3G5Ws/aaYWJvEmDT7nnz+mc4QVkftg=";

  postPatch = ''
    # CLI tests will fail in the sandbox
    rm tests/test_cli_interactive.rs
  '';

  meta = with lib; {
    description = "Parser for the Windows XML Event Log (EVTX) format";
    homepage = "https://github.com/omerbenamram/evtx";
    changelog = "https://github.com/omerbenamram/evtx/blob/v${version}/CHANGELOG.md";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "evtx_dump";
  };
}

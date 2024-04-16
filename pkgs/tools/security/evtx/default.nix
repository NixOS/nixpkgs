{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "evtx";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "omerbenamram";
    repo = "evtx";
    rev = "refs/tags/v${version}";
    hash = "sha256-uuoHDIZ76BfRSb1XXHDwsSQ3ium22FPv1fjrB35liXw=";
  };

  cargoHash = "sha256-OmwfI86Rj0Ph5cXpGzAycEw+A4liki7+gc1iokDBwhU=";

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

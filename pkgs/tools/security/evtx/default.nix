{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "evtx";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "omerbenamram";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-aa04Ia11+Ae1amc3JAtYdSWf+f/fenTt0Bny/AauaHo=";
  };

  cargoHash = "sha256-4pQP+cvKfOvRgWRFa4+/dEpBq+gfcOuEENC5aP4Cp7U=";

  postPatch = ''
    # CLI tests will fail in the sandbox
    rm tests/test_cli_interactive.rs
  '';

  meta = with lib; {
    description = "Parser for the Windows XML Event Log (EVTX) format";
    homepage = "https://github.com/omerbenamram/evtx";
    changelog = "https://github.com/omerbenamram/evtx/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

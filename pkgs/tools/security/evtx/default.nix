{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "evtx";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "omerbenamram";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-T165PZhjuX5tUENZoO6x1u2MpMQTfv9dGRmxyNY2ACg=";
  };

  cargoSha256 = "sha256-qcjJoXB0DV1Z5bhGrtyJzfWqE+tVWBOYMJEd+MWFcD8=";

  postPatch = ''
    # CLI tests will fail in the sandbox
    rm tests/test_cli_interactive.rs
  '';

  meta = with lib; {
    description = "Parser for the Windows XML Event Log (EVTX) format";
    homepage = "https://github.com/omerbenamram/evtx";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

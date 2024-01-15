{ lib
, fetchFromGitHub
, makeWrapper
, rustPlatform
, rust-analyzer
}:

rustPlatform.buildRustPackage {
  pname = "ra-multiplex";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "pr2502";
    repo = "ra-multiplex";
    rev = "dcb5f83890cb91016b0a1590cc1b732606bb6ec1";
    hash = "sha256-Hf4Gj9eXEP4gXiqNV4Jq0oiGLX3DtDF9At1feEZ+bUE=";
  };

  cargoHash = "sha256-MeUtkPjOsL1kQ2W0Q1/OqhKDVXs4cECkATHISpyfp9U=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/ra-multiplex \
      --suffix PATH ${lib.makeBinPath [ rust-analyzer ]}
  '';

  meta = with lib; {
    description = "A multiplexer for rust-analyzer";
    homepage = "https://github.com/pr2502/ra-multiplex";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ norfair ];
  };
}

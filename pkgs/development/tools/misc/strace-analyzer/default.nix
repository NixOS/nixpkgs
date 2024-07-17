{
  lib,
  rustPlatform,
  fetchFromGitHub,
  strace,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "strace-analyzer";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "wookietreiber";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-KbdQeZoWFz4D5txu/411J0HNnIAs3t5IvO30/34vBek=";
  };

  cargoHash = "sha256-t1BFc5cNOQJIbufFH2hHI4f7SMrZ5mwVODXukdbHf3M=";

  nativeCheckInputs = [ strace ];

  checkFlags = lib.optionals stdenv.isAarch64 [
    # thread 'analysis::tests::analyze_dd' panicked at 'assertion failed: ...'
    "--skip=analysis::tests::analyze_dd"
  ];

  meta = with lib; {
    description = "Analyzes strace output";
    mainProgram = "strace-analyzer";
    homepage = "https://github.com/wookietreiber/strace-analyzer";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ figsoda ];
  };
}

{ lib
, rustPlatform
, fetchFromGitHub
, strace
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "strace-analyzer";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "wookietreiber";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-wx0/Jb2uaS1qdRQymfE00IEOyfgLtD4lXYasaJgcoxo=";
  };

  cargoHash = "sha256-3OS3LEEk58+IJDQrgwo+BJq6hblojk22QxDtZY5ofA4=";

  nativeCheckInputs = [ strace ];

  checkFlags = lib.optionals stdenv.isAarch64 [
    # thread 'analysis::tests::analyze_dd' panicked at 'assertion failed: ...'
    "--skip=analysis::tests::analyze_dd"
  ];

  meta = with lib; {
    description = "Analyzes strace output";
    homepage = "https://github.com/wookietreiber/strace-analyzer";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ figsoda ];
  };
}

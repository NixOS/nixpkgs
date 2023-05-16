{ lib
, rustPlatform
, fetchFromGitHub
, strace
<<<<<<< HEAD
, stdenv
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  checkFlags = lib.optionals stdenv.isAarch64 [
    # thread 'analysis::tests::analyze_dd' panicked at 'assertion failed: ...'
    "--skip=analysis::tests::analyze_dd"
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Analyzes strace output";
    homepage = "https://github.com/wookietreiber/strace-analyzer";
    license = licenses.gpl3Plus;
<<<<<<< HEAD
    maintainers = with maintainers; [ figsoda ];
=======
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}

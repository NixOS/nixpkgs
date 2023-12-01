{ lib
, rustPlatform
, fetchFromGitHub
, gmp
, mpfr
, libmpc
}:

rustPlatform.buildRustPackage rec {
  pname = "kalker";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "PaddiM8";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-8tJi4PRGhNCndiMRdZUvCSdx/+p9OhJyJ3AbD+PucSo=";
  };

  cargoHash = "sha256-rGy4tkjjPiV2lpdOtfqjsXgBgi/x+45K4KeUDhyfQoA=";

  buildInputs = [ gmp mpfr libmpc ];

  outputs = [ "out" "lib" ];

  # Cargo.lock is outdated
  preConfigure = ''
    cargo metadata --offline
  '';

  postInstall = ''
    moveToOutput "lib" "$lib"
  '';

  env.CARGO_FEATURE_USE_SYSTEM_LIBS = "1";

  meta = with lib; {
    homepage = "https://kalker.strct.net";
    changelog = "https://github.com/PaddiM8/kalker/releases/tag/v${version}";
    description = "A command line calculator";
    longDescription = ''
      A command line calculator that supports math-like syntax with user-defined
      variables, functions, derivation, integration, and complex numbers
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda lovesegfault ];
    mainProgram = "kalker";
  };
}

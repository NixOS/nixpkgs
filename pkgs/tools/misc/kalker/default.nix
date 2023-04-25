{ lib
, rustPlatform
, fetchFromGitHub
, gmp
, mpfr
, libmpc
}:

rustPlatform.buildRustPackage rec {
  pname = "kalker";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "PaddiM8";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Pj3rcjEbUt+pnmbOZlv2JIvUhVdeiXYDKc5FED6qO7E=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  buildInputs = [ gmp mpfr libmpc ];

  outputs = [ "out" "lib" ];

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  postInstall = ''
    moveToOutput "lib" "$lib"
  '';

  CARGO_FEATURE_USE_SYSTEM_LIBS = "1";

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
  };
}

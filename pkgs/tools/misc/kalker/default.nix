{ lib
, rustPlatform
, fetchFromGitHub
, gmp
, mpfr
, libmpc
}:

rustPlatform.buildRustPackage rec {
  pname = "kalker";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "PaddiM8";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-oBdo/FQZsJnUwhGrBuRWKZIvw2lZab9N/rv/muofs04=";
  };

  cargoHash = "sha256-v4biE3J1a3qxiqJrSTFxyZhOJpoCnh2lZFBjy4O3XiE=";

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

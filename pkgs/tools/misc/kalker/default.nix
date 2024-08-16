{ lib
, rustPlatform
, fetchFromGitHub
, gmp
, mpfr
, libmpc
}:

rustPlatform.buildRustPackage rec {
  pname = "kalker";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "PaddiM8";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Ri0Os+/AqGWgf/2V5D7xvelOC3JTOMjNzjq56mhA3G4=";
  };

  cargoHash = "sha256-0+NYbVMIUarLppBZu6mtyGd+2fvkjEUq0TX7urBq3XI=";

  buildInputs = [ gmp mpfr libmpc ];

  outputs = [ "out" "lib" ];

  postInstall = ''
    moveToOutput "lib" "$lib"
  '';

  env.CARGO_FEATURE_USE_SYSTEM_LIBS = "1";

  meta = with lib; {
    homepage = "https://kalker.strct.net";
    changelog = "https://github.com/PaddiM8/kalker/releases/tag/v${version}";
    description = "Command line calculator";
    longDescription = ''
      A command line calculator that supports math-like syntax with user-defined
      variables, functions, derivation, integration, and complex numbers
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda lovesegfault ];
    mainProgram = "kalker";
  };
}

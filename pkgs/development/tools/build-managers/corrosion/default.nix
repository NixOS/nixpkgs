{ lib
, stdenv
, fetchFromGitHub
, cargo
, cmake
, rustPlatform
, rustc
, libiconv
}:

stdenv.mkDerivation rec {
  pname = "corrosion";
<<<<<<< HEAD
  version = "0.4.3";
=======
  version = "0.3.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "corrosion-rs";
    repo = "corrosion";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Bvx4Jvd/l1EHB3eoBEizuT4Lou4Ev+CPA7D7iWIe+No=";
=======
    hash = "sha256-r/jrck4RiQynH1+Hx4GyIHpw/Kkr8dHe1+vTHg+fdRs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  cargoRoot = "generator";

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sourceRoot = "${src.name}/${cargoRoot}";
    name = "${pname}-${version}";
<<<<<<< HEAD
    hash = "sha256-0n45edWVSaYQS+S0H4p55d+ZgD6liHn6iBd3qCtjAh8=";
=======
    hash = "sha256-d4ep2v1aMQJUiMwwM0QWZo8LQosJoSeVIEx7JXkXHt8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  nativeBuildInputs = [
    cmake
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  meta = with lib; {
    description = "Tool for integrating Rust into an existing CMake project";
    homepage = "https://github.com/corrosion-rs/corrosion";
    changelog = "https://github.com/corrosion-rs/corrosion/blob/${src.rev}/RELEASES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}

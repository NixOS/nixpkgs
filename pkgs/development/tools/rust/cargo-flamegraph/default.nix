{ lib, stdenv, fetchFromGitHub, rustPlatform, makeWrapper, perf, nix-update-script
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-flamegraph";
<<<<<<< HEAD
  version = "0.6.3";
=======
  version = "0.6.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "flamegraph-rs";
    repo = "flamegraph";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-npPE9dB7yxIfCxq3NGgI1J6OkDI7qfsusY/dD9w3bp4=";
  };

  cargoSha256 = "sha256-m92PT89uTuJWlGAAL/wopHYv7vXaRd3woEW70S7kVUI=";
=======
    sha256 = "sha256-LYoyMEALxeUQQI2pBL1u0Q9rrwyy6N6Dg5bNxhJiVrM=";
  };

  cargoSha256 = "sha256-t8+bjTRQMuXTYhgW1NuC3MXsRh2SMeycyyq4x1nb9MU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = lib.optionals stdenv.isLinux [ makeWrapper ];
  buildInputs = lib.optionals stdenv.isDarwin [
    Security
  ];

  postFixup = lib.optionalString stdenv.isLinux ''
    wrapProgram $out/bin/cargo-flamegraph \
      --set-default PERF ${perf}/bin/perf
    wrapProgram $out/bin/flamegraph \
      --set-default PERF ${perf}/bin/perf
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Easy flamegraphs for Rust projects and everything else, without Perl or pipes <3";
    homepage = "https://github.com/flamegraph-rs/flamegraph";
    license = with licenses; [ asl20 /* or */ mit ];
<<<<<<< HEAD
    maintainers = with maintainers; [ killercup matthiasbeyer ];
=======
    maintainers = with maintainers; [ killercup ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}

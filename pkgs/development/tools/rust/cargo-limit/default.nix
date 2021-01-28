{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-limit";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "alopatindev";
    repo = "cargo-limit";
    rev = version;
    sha256 = "0ky62hbf6byxci28vqsps4xkf4r8irz5rz9q1pfmr68ls7bwywm7";
  };

  cargoPatches = [ ./cargo-Add-Cargo.lock.patch ];

  cargoSha256 = "0vdpz7xhkf05fr430hz00w0d2ghjhmhmpi89jzcdw1cmrnidywly";

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with lib; {
    description = "Cargo subcommand \"limit\": reduces the noise of compiler messages";
    homepage = "https://github.com/alopatindev/cargo-limit";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ otavio ];
  };
}

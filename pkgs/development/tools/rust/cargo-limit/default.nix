{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-limit";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "alopatindev";
    repo = "cargo-limit";
    rev = version;
    sha256 = "sha256-2YngMRPNiUVqg82Ck/ovcMbZV+STGyowT9zlwBkcKok=";
  };

  cargoSha256 = "sha256-4HQhBE4kNhOhO48PBiAxtppmaqy7jaV8p/jb/Uv7vJk=";

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

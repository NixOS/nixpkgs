{ lib, stdenv
, rustPlatform
, fetchFromGitHub
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-wipe";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "mihai-dinculescu";
    repo = "cargo-wipe";
    rev = "v${version}";
    sha256 = "1kwkifdp98zsinh7xcsz2va252wxbw73xlrv0r7h3m0bn51d52vw";
  };

  cargoSha256 = "15snr1b1pybwcjzwddxybvry3jyllcmrp8dyfm9yiagks3wrcfb4";

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with lib; {
    description = ''Cargo subcommand "wipe": recursively finds and optionally wipes all "target" or "node_modules" folders'';
    homepage = "https://github.com/mihai-dinculescu/cargo-wipe";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ otavio ];
  };
}

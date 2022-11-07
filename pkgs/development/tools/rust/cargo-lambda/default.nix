{ stdenv, lib, rustPlatform, fetchFromGitHub, makeWrapper, cargo-watch, zig, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-lambda";
  version = "0.11.3";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dEJOoV91DIQL7KPbLQrgCKdCF7ZMSZMHVLq6l1sg4F0=";
  };

  cargoSha256 = "sha256-qW4a4VPpPSdt0Z4nRA4/fHpW0cfDxOPQyEAdJidt+0o=";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/cargo-lambda --prefix PATH : ${lib.makeBinPath [ cargo-watch zig ]}
  '';

  checkFlags = [
    # Disabled because it accesses the network.
    "--skip test_download_example"
    # Disabled because it makes assumptions about the file system.
    "--skip test_target_dir_from_env"
  ];

  meta = with lib; {
    description = "A Cargo subcommand to help you work with AWS Lambda";
    homepage = "https://cargo-lambda.info";
    license = licenses.mit;
    maintainers = with maintainers; [ taylor1791 calavera ];
  };
}

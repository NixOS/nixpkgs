{ stdenv, lib, rustPlatform, fetchFromGitHub, makeWrapper, cargo-watch, zig, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-lambda";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-SgA2eKXZIPWbyJkopk8E9rTgkUWl6LWP2dw2fn3H8qc=";
  };

  cargoSha256 = "sha256-rTVc8zzbzLzP0LV8h7IWE1S+ZqDVfnO18iT0CrOrI9A=";

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

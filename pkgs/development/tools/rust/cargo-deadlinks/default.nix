{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-deadlinks";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "deadlinks";
    repo = pname;
    rev = version;
    sha256 = "0s5q9aghncsk9834azn5cgnn5ms3zzyjan2rq06kaqcgzhld4cjh";
  };

  cargoSha256 = "00g06zf0m1wry0mhf098pw99kbb99d8a17985pb90yf1w74rdkh6";

  checkFlags =
    [
      # uses internet
      "--skip non_existent_http_link --skip working_http_check"
    ]
    ++ lib.optional (stdenv.hostPlatform.system != "x86_64-linux")
      # assumes the target is x86_64-unknown-linux-gnu
      "--skip simple_project::it_checks_okay_project_correctly";

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "Cargo subcommand to check rust documentation for broken links";
    homepage = "https://github.com/deadlinks/cargo-deadlinks";
    changelog = "https://github.com/deadlinks/cargo-deadlinks/blob/${version}/CHANGELOG.md";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [
      newam
      matthiasbeyer
    ];
  };
}

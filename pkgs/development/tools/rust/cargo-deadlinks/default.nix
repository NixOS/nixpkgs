{ lib, stdenv, rustPlatform, fetchFromGitHub, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-deadlinks";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "deadlinks";
    repo = pname;
    rev = "${version}";
    sha256 = "1zd5zgq3346xijllr0qdvvmsilpawisrqgdmsqir8v3bk55ybj4g";
  };

  cargoSha256 = "1ar3iwpy9mng4j09z4g3ynxra2qwc8454dnc0wjal4h16fk8gxwv";

  checkFlags = [
    # uses internet
    "--skip non_existent_http_link --skip working_http_check"
    # expects top-level directory to be named "cargo-deadlinks"
    "--skip simple_project::it_checks_okay_project_correctly"
  ];

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "Cargo subcommand to check rust documentation for broken links";
    homepage = "https://github.com/deadlinks/cargo-deadlinks";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ newam ];
  };
}

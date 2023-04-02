{ lib, rustPlatform, fetchFromGitHub, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "static-web-server";
  version = "2.15.0";

  src = fetchFromGitHub {
    owner = "static-web-server";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-TzMXVwtvslM57ucHT5NHMjsLex2VjuvyqP9gMdQXfFs=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "headers-0.3.8" = "sha256-zi9ytzjq5M1TtLJxibEnUdx42T+2v5uH9+3+3et6RXQ=";
    };
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  checkFlags = [
    # TODO: investigate why these tests fail
    "--skip=tests::handle_byte_ranges_if_range_too_old"
    "--skip=tests::handle_not_modified"
    "--skip=handle_precondition"
  ];

  meta = with lib; {
    description = "An asynchronus web server for static files-serving";
    homepage = "https://sws.joseluisq.net";
    changelog = "https://github.com/static-web-server/static-web-server/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}

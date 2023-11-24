{ lib, rustPlatform, fetchFromGitHub, stdenv, darwin, nixosTests }:

rustPlatform.buildRustPackage rec {
  pname = "static-web-server";
  version = "2.24.1";

  src = fetchFromGitHub {
    owner = "static-web-server";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-U+B/k/stwjJw+mxUCb4A3yUtc/+Tg0PsWhVnovLLX4A=";
  };

  cargoHash = "sha256-ZDrRjIM8187nr72MlzFr0NAqH2f8qkF1sGAT9+NvfhA=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  checkFlags = [
    # TODO: investigate why these tests fail
    "--skip=tests::handle_byte_ranges_if_range_too_old"
    "--skip=tests::handle_not_modified"
    "--skip=handle_precondition"
  ];

  # Need to copy in the systemd units for systemd.packages to discover them
  postInstall = ''
    install -Dm444 -t $out/lib/systemd/system/ systemd/static-web-server.{service,socket}
  '';

  passthru.tests = { inherit (nixosTests) static-web-server; };

  meta = with lib; {
    description = "An asynchronous web server for static files-serving";
    homepage = "https://static-web-server.net/";
    changelog = "https://github.com/static-web-server/static-web-server/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}

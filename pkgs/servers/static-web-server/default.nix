{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "static-web-server";
  version = "2.32.1";

  src = fetchFromGitHub {
    owner = "static-web-server";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-PkDT6FU6JSIeeKCJeeIjjqZfoo+tGzqyPyWuIiwusQY=";
  };

  cargoHash = "sha256-ymI5O6j6NEcgIbMLEYgyUZBBkwxDWDWaVn4hqJScGxA=";

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  # Lots of tests fail due to unexpected argument '--test-threads' because CLI options of
  # test runner is being parsed
  doCheck = false;

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

  passthru.tests = {
    inherit (nixosTests) static-web-server;
  };

  meta = with lib; {
    description = "Asynchronous web server for static files-serving";
    homepage = "https://static-web-server.net/";
    changelog = "https://github.com/static-web-server/static-web-server/blob/v${version}/CHANGELOG.md";
    license = with licenses; [
      mit # or
      asl20
    ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "static-web-server";
  };
}

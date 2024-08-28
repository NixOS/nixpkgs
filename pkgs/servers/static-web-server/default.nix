{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch,
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

  patches = [
    (fetchpatch {
      url = "https://github.com/static-web-server/static-web-server/pull/466.patch";
      hash = "sha256-VYSoi6swG4nEFmGKvdEaJ05mJlxaXYsjs8cQai40P4g=";
    })
  ];

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  # Some tests rely on timestamps newer than 18 Nov 1974 00:00:00
  preCheck = ''
    find docker/public -exec touch -m {} \;
  '';

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

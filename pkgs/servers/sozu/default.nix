{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, darwin
, protobuf
, nix-update-script
, testers
, sozu
}:

rustPlatform.buildRustPackage rec {
  pname = "sozu";
  version = "0.15.3";

  src = fetchFromGitHub {
    owner = "sozu-proxy";
    repo = pname;
    rev = version;
    hash = "sha256-hZQ5pRzQy+BMGnxCl0Mw3hqCHZJcZ30vhqt6gWyLXWU=";
  };

  cargoHash = "sha256-KFOsKyZZOWvkkTuLqVeLmHlk6HscEJi0sI2hJS6UnOU=";

  nativeBuildInputs = [ protobuf ];

  buildInputs =
    lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

  doCheck = false;

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = sozu;
      command = "sozu --version";
      version = "${version}";
    };
  };

  meta = with lib; {
    description =
      "Open Source HTTP Reverse Proxy built in Rust for Immutable Infrastructures";
    homepage = "https://www.sozu.io";
    changelog = "https://github.com/sozu-proxy/sozu/releases/tag/${version}";
    license = licenses.agpl3;
    maintainers = with maintainers; [ Br1ght0ne gaelreyrol ];
    # error[E0432]: unresolved import `std::arch::x86_64`
    broken = !stdenv.isx86_64;
  };
}

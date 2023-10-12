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
  version = "0.15.6";

  src = fetchFromGitHub {
    owner = "sozu-proxy";
    repo = pname;
    rev = version;
    hash = "sha256-8JvSVqU8JSf7VrHYxKTZWsX59gMW7eRg4WHrvemhUNU=";
  };

  cargoHash = "sha256-f4tteNovor8/YS71SbpD0GlHXEHfLmZmOLxn8impRj8=";

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
    mainProgram = "sozu";
    # error[E0432]: unresolved import `std::arch::x86_64`
    broken = !stdenv.isx86_64;
  };
}

{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, darwin
, protobuf
, nixosTests
, nix-update-script
, testers
, sozu
}:

rustPlatform.buildRustPackage rec {
  pname = "sozu";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "sozu-proxy";
    repo = pname;
    rev = version;
    hash = "sha256-ftM5PTxjyhYd2182HjaNeDC/ulZHoPBgE9O0MscotEs=";
  };

  cargoHash = "sha256-aC+0ZobFilRk3X20ubtEt9VdfySdQgBDy7TIvpttDEc=";

  nativeBuildInputs = [ protobuf ];

  buildInputs =
    lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

  doCheck = false;

  passthru = {
    tests = {
      inherit (nixosTests) sozu;
      version = testers.testVersion {
        package = sozu;
        command = "sozu --version";
        version = "${version}";
      };
    };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description =
      "Open Source HTTP Reverse Proxy built in Rust for Immutable Infrastructures";
    homepage = "https://www.sozu.io";
    changelog = "https://github.com/sozu-proxy/sozu/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ Br1ght0ne gaelreyrol ];
    mainProgram = "sozu";
    # error[E0432]: unresolved import `std::arch::x86_64`
    broken = !stdenv.isx86_64;
  };
}

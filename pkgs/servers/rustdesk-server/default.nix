{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libsodium,
  Security,
  sqlite,
  nix-update-script,
  testers,
  rustdesk-server,
}:

rustPlatform.buildRustPackage rec {
  pname = "rustdesk-server";
  version = "1.1.11-1";

  src = fetchFromGitHub {
    owner = "rustdesk";
    repo = "rustdesk-server";
    rev = version;
    hash = "sha256-dAw1xKyZovPkz1qw58QymIvv7ABhmHs2lFx/H6g7GgI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-BP+7Zt2GqI5PQZU7GZs3yJkIAmONOl5YpCtTzrKqVko=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      libsodium
      sqlite
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      Security
    ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      inherit version;
      package = rustdesk-server;
      command = "hbbr --version";
    };
  };

  meta = with lib; {
    description = "RustDesk Server Program";
    homepage = "https://github.com/rustdesk/rustdesk-server";
    changelog = "https://github.com/rustdesk/rustdesk-server/releases/tag/${version}";
    license = licenses.agpl3Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      gaelreyrol
      tjni
    ];
  };
}

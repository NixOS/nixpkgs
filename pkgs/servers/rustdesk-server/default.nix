{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libsodium
, Security
, sqlite
, nix-update-script
, testers
, rustdesk-server
}:

rustPlatform.buildRustPackage rec {
  pname = "rustdesk-server";
  version = "1.1.9";

  src = fetchFromGitHub {
    owner = "rustdesk";
    repo = "rustdesk-server";
    rev = version;
    hash = "sha256-bC1eraMSa9Lz5icvU7dPnEIeqE5TaW8HseBQMRmDCXQ=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "async-speed-limit-0.3.1" = "sha256-iOel6XA07RPrBjQAFLnxXX4VBpDrYZaqQc9clnsOorI=";
      "confy-0.4.0" = "sha256-e91cvEixhpPzIthAxzTa3fDY6eCsHUy/eZQAqs7QTDo=";
      "tokio-socks-0.5.1" = "sha256-inmAJk0fAlsVNIwfD/M+htwIdQHwGSTRrEy6N/mspMI=";
    };
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libsodium
    sqlite
  ] ++ lib.optionals stdenv.isDarwin [
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
    maintainers = with maintainers; [ gaelreyrol tjni ];
  };
}

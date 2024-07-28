{ lib
, fetchFromGitHub
, rustPlatform
, nodejs
, git
, python39
, nixosTests
}:

rustPlatform.buildRustPackage rec {
  pname = "cjdns";
  date = "2024-06-26";
  version = "22-unstable-${date}";

  src = fetchFromGitHub {
    owner = "cjdelisle";
    repo = "cjdns";
    rev = "3e61aa36d92a4a0171c2e7586b3a14dac7b90df8";
    sha256 = "sha256-qDiofLQ0xK/gHF7tdXgHIRuS9OnrxNUW+u9lvOXHQ9o=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "libsodium-sys-0.2.6" = "sha256-icnA8IEvuu/KxtA23l0jdpw28VPfFJvnMUE7sb8QgK4=";
      "boringtun-0.3.0" = "1r7s3jfjxsxj40v8qgd1m0ng6k8p9kf87zrdzkfcyhhvv3l4snis";
      "cjdns-crypto-0.1.0" = "00hhk7xwk58lmqapx3fxs5b47fl8iyqfxa1bp8d0g3fipa1nr81c";
    };
  };

  checkFlags = [
    # Skip dysfunctional tests (no longer covered by cjdns's 'do' build script)
    "--skip=crypto::crypto_auth::tests::test_wireguard_iface_encrypt_decrypt"
    "--skip=crypto::crypto_auth::tests::test_wireguard_iface_encrypt_decrypt_with_auth"
  ];

  nativeBuildInputs = [
    python39
    nodejs
    git
  ];

  passthru.tests.basic = nixosTests.cjdns;

  meta = with lib; {
    homepage = "https://github.com/cjdelisle/cjdns";
    description = "Encrypted networking for regular people";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ehmry ];
    platforms = platforms.linux;
  };
}

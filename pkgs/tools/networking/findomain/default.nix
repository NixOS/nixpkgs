{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, pkg-config
, openssl
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "findomain";
  version = "9.0.0";

  src = fetchFromGitHub {
    owner = "findomain";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-xiy4HiKgUW7U3GCjR5ZxPHILpDxG6xsADCAzGraqOPc=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "fhc-0.7.1" = "sha256-bLlaQN9HdAUt6kgP7ToVkZwwD0fNsNMmXn+BtxP52Ss=";
      "headless_chrome-0.9.0" = "sha256-0BMm0tmCbUL1BSdD6rJLG735FYJsmkSrPQBs2zWx414=";
      "rusolver-0.9.1" = "sha256-84qe/A+FN8Q+r8tk0waOq+sBgnDpG9bwoQI+K5pE4Wc=";
      "trust-dns-proto-0.20.4" = "sha256-+oAjyyTXbKir8e5kn8CUmQy5qmzQ47ryvBBdZtzj1TY=";
    };
  };

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  postInstall = ''
    installManPage findomain.1
  '';

  meta = with lib; {
    description = "The fastest and cross-platform subdomain enumerator";
    homepage = "https://github.com/Findomain/Findomain";
    changelog = "https://github.com/Findomain/Findomain/releases/tag/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ Br1ght0ne figsoda ];
  };
}

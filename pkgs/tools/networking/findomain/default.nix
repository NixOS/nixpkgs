{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, pkg-config
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "findomain";
  version = "9.0.3";

  src = fetchFromGitHub {
    owner = "findomain";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-M6i62JI4HjaM0C2rSK8P5O19JeugFP5xIy1E6vE8KP4=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "fhc-0.7.1" = "sha256-gSAwpuVL+5vLkHTsh60qyza7IoxgUWBQcWl2N7md51s=";
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
    darwin.apple_sdk.frameworks.SystemConfiguration
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
    mainProgram = "findomain";
  };
}

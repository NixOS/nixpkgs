{
  lib,
  stdenv,
  fetchFromGitHub,
  nmap,
  perl,
  python3,
  rustPlatform,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "rustscan";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "RustScan";
    repo = "RustScan";
    rev = "refs/tags/${version}";
    hash = "sha256-6heC/bHo4IqKNvPjch7AiyWTCZDCv4MZHC7DTEX3U5c=";
  };

  cargoHash = "sha256-Fr+m4BeYvUOoSkewwdUgpmdNchweeLK7v/tKLEzFOBs=";

  postPatch = ''
    substituteInPlace src/scripts/mod.rs \
      --replace-fail 'call_format = "nmap' 'call_format = "${nmap}/bin/nmap'
    patchShebangs fixtures/.rustscan_scripts/*
  '';

  buildInputs = lib.optional stdenv.isDarwin Security;

  nativeCheckInputs = [
    perl
    python3
  ];

  checkFlags = [
    # These tests require network access
    "--skip=parse_correct_host_addresses"
    "--skip=parse_hosts_file_and_incorrect_hosts"
    "--skip=resolver_args_google_dns"
    "--skip=resolver_default_cloudflare"
  ];

  meta = with lib; {
    description = "Faster Nmap Scanning with Rust";
    homepage = "https://github.com/RustScan/RustScan";
    changelog = "https://github.com/RustScan/RustScan/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "rustscan";
  };
}

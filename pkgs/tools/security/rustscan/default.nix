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
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "RustScan";
    repo = "RustScan";
    tag = version;
    hash = "sha256-+qPSeDpOeCq+KwZb5ANXx6z+pYbgdT1hVgcrSzxyGp0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-cUuInYCT2jzen9gswfFGtKum6w2X/SiKA2ccdmxk38A=";

  postPatch = ''
    substituteInPlace src/scripts/mod.rs \
      --replace-fail 'call_format = "nmap' 'call_format = "${nmap}/bin/nmap'
    patchShebangs fixtures/.rustscan_scripts/*
  '';

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin Security;

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

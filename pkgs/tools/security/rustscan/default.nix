{ lib
, stdenv
, rustPlatform
, fetchCrate
, nmap
, Security
, perl
, python3
}:

rustPlatform.buildRustPackage rec {
  pname = "rustscan";
  version = "2.1.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-yGVhbI1LivTIQEgqOK59T1+8SiTJBPIdftiXkwE4lZM=";
  };

  cargoHash = "sha256-UR3ktV80QU0N3f7qmqdhYpc5uwoPq4UvN40zEuMbp+Q=";

  postPatch = ''
    substituteInPlace src/scripts/mod.rs \
      --replace-fail 'call_format = "nmap' 'call_format = "${nmap}/bin/nmap'
    patchShebangs fixtures/.rustscan_scripts/*
  '';

  buildInputs = lib.optional stdenv.isDarwin Security;

  nativeCheckInputs = [ perl python3 ];

  # these tests require network access
  checkFlags = [
    "--skip=parse_correct_host_addresses"
    "--skip=parse_hosts_file_and_incorrect_hosts"
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

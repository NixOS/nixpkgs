{ lib, rustPlatform, fetchCrate, nmap, stdenv, Security, perl, python3 }:

rustPlatform.buildRustPackage rec {
  pname = "rustscan";
  version = "2.1.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-yGVhbI1LivTIQEgqOK59T1+8SiTJBPIdftiXkwE4lZM=";
  };

  cargoSha256 = "sha256-UR3ktV80QU0N3f7qmqdhYpc5uwoPq4UvN40zEuMbp+Q=";

  postPatch = ''
    substituteInPlace src/scripts/mod.rs \
      --replace 'call_format = "nmap' 'call_format = "${nmap}/bin/nmap'
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
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
  };
}

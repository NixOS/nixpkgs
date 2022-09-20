{ lib, rustPlatform, fetchCrate, nmap, stdenv, Security, perl, python3 }:

rustPlatform.buildRustPackage rec {
  pname = "rustscan";
  version = "2.1.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-f9QFsVGGKoWqZGIg8Z8FgZGcUo5M8MFNUavK69SgHkg=";
  };

  cargoSha256 = "sha256-ZoDE7SJ6snWTFvYXHZdVCC6UCug2wGghH93FfDTDsv0=";

  postPatch = ''
    substituteInPlace src/scripts/mod.rs \
      --replace 'call_format = "nmap' 'call_format = "${nmap}/bin/nmap'
    patchShebangs fixtures/.rustscan_scripts/*
  '';

  buildInputs = lib.optional stdenv.isDarwin Security;

  checkInputs = [ perl python3 ];

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

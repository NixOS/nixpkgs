{ lib, stdenv, fetchFromGitHub, rustPlatform, nmap, Security }:

rustPlatform.buildRustPackage rec {
  pname = "rustscan";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "RustScan";
    repo = pname;
    rev = version;
    sha256 = "0fdbsz1v7bb5dm3zqjs1qf73lb1m4qzkqyb3h3hbyrp9vklgxsgw";
  };

  cargoSha256 = "0658jbx59qrsgpfczzlfrbp2qm7kh0c5561bsxzmgiri7fcz9w0n";

  postPatch = ''
    substituteInPlace src/main.rs \
      --replace 'Command::new("nmap")' 'Command::new("${nmap}/bin/nmap")'
  '';

  buildInputs = lib.optional stdenv.isDarwin Security;

  checkFlags = [
    "--skip=infer_ulimit_lowering_no_panic"
    "--skip=google_dns_runs"
    "--skip=parse_correct_host_addresses"
    "--skip=parse_hosts_file_and_incorrect_hosts"
    "--skip=run_perl_script"
    "--skip=run_python_script"
  ];

  meta = with lib; {
    description = "Faster Nmap Scanning with Rust";
    homepage = "https://github.com/RustScan/RustScan";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
  };
}

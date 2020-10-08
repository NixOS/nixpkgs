{ lib
, fetchFromGitHub
, rustPlatform
, nmap
}:

rustPlatform.buildRustPackage rec {
  pname = "rustscan";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "RustScan";
    repo = pname;
    rev = "${version}";
    sha256 = "0rkqsh4i58cf18ad97yr4f68s5jg6z0ybz4bw8607lz7cjkfvjay";
  };

  cargoSha256 = "0mj214f2md7kjknmcayc5dcfmlk2b8mqkn7kxzdis8qv9a5xcbk8";

  postPatch = ''
    substituteInPlace src/main.rs \
      --replace 'Command::new("nmap")' 'Command::new("${nmap}/bin/nmap")'
  '';

  checkFlags = [
    "--skip=infer_ulimit_lowering_no_panic"
    "--skip=google_dns_runs"
    "--skip=parse_correct_ips_or_hosts"
  ];

  meta = with lib; {
    description = "Faster Nmap Scanning with Rust";
    homepage = "https://github.com/RustScan/RustScan";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.SuperSandro2000 ];
  };
}

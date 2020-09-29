{ lib
, fetchFromGitHub
, rustPlatform
, nmap
}:

rustPlatform.buildRustPackage rec {
  pname = "rustscan";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "RustScan";
    repo = pname;
    rev = "${version}";
    sha256 = "1x6vi3d250jhy75ybp8gm6cq9ncv0jig5c1v12r26raflhkh7fk3";
  };

  cargoSha256 = "0q4p4pa1lh8kw5gmiim0zmmvs3l1kl319a3ji7gmj2fisha4319k";

  postPatch = ''
    substituteInPlace src/main.rs \
      --replace 'Command::new("nmap")' 'Command::new("${nmap}/bin/nmap")'
  '';

  checkFlags = [
    "--skip=infer_ulimit_lowering_no_panic"
    "--skip=google_dns_runs"
    "--skip=parse_correct_host_addresses"
  ];

  meta = with lib; {
    description = "Faster Nmap Scanning with Rust";
    homepage = "https://github.com/RustScan/RustScan";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.SuperSandro2000 ];
  };
}

{ stdenv, fetchFromGitHub, rustPlatform, nmap, Security }:

rustPlatform.buildRustPackage rec {
  pname = "rustscan";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "RustScan";
    repo = pname;
    rev = version;
    sha256 = "0dhy7b73ipsxsr7wlc3r5yy39i3cjrdszhsw9xwjj31692s3b605";
  };

  cargoSha256 = "00s1iv8yw06647ijw9p3l5n7d899gsks5j8ljag6ha7hgl5vs4ci";

  postPatch = ''
    substituteInPlace src/main.rs \
      --replace 'Command::new("nmap")' 'Command::new("${nmap}/bin/nmap")'
  '';

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  checkFlags = [
    "--skip=infer_ulimit_lowering_no_panic"
    "--skip=google_dns_runs"
    "--skip=parse_correct_host_addresses"
    "--skip=parse_hosts_file_and_incorrect_hosts"
  ];

  meta = with stdenv.lib; {
    description = "Faster Nmap Scanning with Rust";
    homepage = "https://github.com/RustScan/RustScan";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.SuperSandro2000 ];
  };
}

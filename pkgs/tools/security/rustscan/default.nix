{ lib
, fetchFromGitHub
, rustPlatform
, nmap
}:

rustPlatform.buildRustPackage rec {
  pname = "rustscan";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "RustScan";
    repo = pname;
    rev = "${version}";
    sha256 = "0hj7k3yrd5vwxarn1kmxlhj5xlcg71w0vrzgnyrzbcppfxrbrj1m";
  };

  cargoSha256 = "0cknnhzkk7jyi436c4hxif455xxdwg9pc4kw1q1wmgnqdw340xin";

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

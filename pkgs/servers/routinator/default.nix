{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "routinator";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-rxCgW4cuYNSJ9P+cBYWAYJsghz2bp9mpAh6AuwLoV5o=";
  };

  cargoSha256 = "0fcp4b2b0mjddj4blr20gvp1ih3ldzzr04rm1m06i8d2lnl68i79";

  meta = with lib; {
    description = "An RPKI Validator written in Rust";
    homepage = "https://github.com/NLnetLabs/routinator";
    license = licenses.bsd3;
    maintainers = with maintainers; [ _0x4A6F ];
    platforms = platforms.linux;
  };
}

{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "emplace";
  version = "0.2.19";

  src = fetchFromGitHub {
    owner = "tversteeg";
    repo = pname;
    rev = "v${version}";
    sha256 = "0vw0axnb7gil6lr72rixp4v3pspi0jq99x8h954mdcff2jr031x5";
  };

  cargoSha256 = "118rxiwvi9k6jq5y0k7yn4w9zlb0fd6xdcyrv38ipr8qrj16cjrq";

  meta = with lib; {
    description = "Mirror installed software on multiple machines";
    homepage = "https://github.com/tversteeg/emplace";
    license = licenses.agpl3;
    maintainers = with maintainers; [ filalex77 ];
  };
}

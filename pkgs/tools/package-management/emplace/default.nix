{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "emplace";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "tversteeg";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lBCGSeEVxlXrn1RHqMEYSXLOehJw/DiL+33nx4+rV2Y=";
  };

  cargoSha256 = "sha256-7LpUaOeBTIpi6A3cTRQAc1QostRgJp6bOf+AXy3mjyE=";

  meta = with lib; {
    description = "Mirror installed software on multiple machines";
    homepage = "https://github.com/tversteeg/emplace";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}

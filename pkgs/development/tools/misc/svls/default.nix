{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "svls";
  version = "0.1.27";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = "svls";
    rev = "v${version}";
    sha256 = "sha256-+/4D0pRZs1Gy6DJnsDZA8wWi1FKhr7gRS0oq1TyWpuE=";
  };

  cargoSha256 = "sha256-xkRlUXlkXQwvzIuhExf+tSSBi+8BZv58btvln05UI+k=";

  meta = with lib; {
    description = "SystemVerilog language server";
    homepage = "https://github.com/dalance/svls";
    license = licenses.mit;
    maintainers = with maintainers; [ trepetti ];
  };
}

{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "svls";
  version = "0.1.25";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = "svls";
    rev = "v${version}";
    sha256 = "sha256-+o15rElJZXQu2Hq1/79ms9wqYimINrViSdQltSJlGN8=";
  };

  cargoSha256 = "sha256-Q0NDiaQYUOxDkxasbMGBdvrfg9UmII+j5hIQwi+2mk8=";

  meta = with lib; {
    description = "SystemVerilog language server";
    homepage = "https://github.com/dalance/svls";
    license = licenses.mit;
    maintainers = with maintainers; [ trepetti ];
  };
}

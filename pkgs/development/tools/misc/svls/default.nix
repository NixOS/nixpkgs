{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "svls";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = "svls";
    rev = "v${version}";
    sha256 = "sha256-SeVLQ05vPywSOnOEhJhQXYhdptmIhvYbbf9SX5eVzik=";
  };

  cargoSha256 = "sha256-jp84LqFuK6Du2mWmgvadD7p8n/zcLKAKBOMQiERTKBI=";

  meta = with lib; {
    description = "SystemVerilog language server";
    homepage = "https://github.com/dalance/svls";
    license = licenses.mit;
    maintainers = with maintainers; [ trepetti ];
  };
}

{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "svls";
  version = "0.2.11";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = "svls";
    rev = "v${version}";
    sha256 = "sha256-pvvtJOwb9N7CzCXoLG19iuLQjABABaOUe6wKfYizgQc=";
  };

  cargoHash = "sha256-sMprdvBSfCIzoTHyUC447pyZWGgZkKa9t3A9BiGbQvY=";

  meta = with lib; {
    description = "SystemVerilog language server";
    homepage = "https://github.com/dalance/svls";
    license = licenses.mit;
    maintainers = with maintainers; [ trepetti ];
  };
}

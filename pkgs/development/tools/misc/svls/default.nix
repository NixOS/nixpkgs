{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "svls";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = "svls";
    rev = "v${version}";
    sha256 = "sha256-WZuFYiPV6HbBH9QT4h9FbnmkbFBadUaV0HujiQ0hu7I=";
  };

  cargoSha256 = "sha256-tafxN3ots1UTSv950NlwCs6TItMnKz5tn5vw7PTcARU=";

  meta = with lib; {
    description = "SystemVerilog language server";
    homepage = "https://github.com/dalance/svls";
    license = licenses.mit;
    maintainers = with maintainers; [ trepetti ];
  };
}

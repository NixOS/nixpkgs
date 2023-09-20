{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "svls";
  version = "0.2.9";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = "svls";
    rev = "v${version}";
    sha256 = "sha256-u07HuWKtZUvK66Do9GFnFRQUwyxfNdtVvNZ+aLDmBrE=";
  };

  cargoHash = "sha256-KpK4yfvYhxqVGq2JB2SRtIQ6MQQhjXEYSIzi0SZgvY4=";

  meta = with lib; {
    description = "SystemVerilog language server";
    homepage = "https://github.com/dalance/svls";
    license = licenses.mit;
    maintainers = with maintainers; [ trepetti ];
  };
}

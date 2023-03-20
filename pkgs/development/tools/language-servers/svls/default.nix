{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "svls";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = "svls";
    rev = "v${version}";
    sha256 = "sha256-+auy6LfvT7OCCSM/WNjnzFsBTAHS+kcghOaMpG3f9dA=";
  };

  cargoHash = "sha256-ZNYYb0Ji4AmiXfhKMPK/4MPfFYSmnUeeeTmiq6rpBvg=";

  meta = with lib; {
    description = "SystemVerilog language server";
    homepage = "https://github.com/dalance/svls";
    license = licenses.mit;
    maintainers = with maintainers; [ trepetti ];
  };
}

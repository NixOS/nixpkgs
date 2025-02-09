{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "xq";
  version = "0.2.44";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-szrt5msjAfiWFMBHVXxqXmLCpvKre8WM/zqCOHwBEP0=";
  };

  cargoHash = "sha256-T8H9Xnvfewf6B60AzBDn3gEps/0/dXiVl2g+eTw+OaQ=";

  meta = with lib; {
    description = "Pure rust implementation of jq";
    homepage = "https://github.com/MiSawa/xq";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
    mainProgram = "xq";
  };
}

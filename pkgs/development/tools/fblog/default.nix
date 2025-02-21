{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "fblog";
  version = "4.12.0";

  src = fetchFromGitHub {
    owner = "brocode";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-OZE+jqjsyvHLDJ+6r0txH56afufnl4H9PHcG7XRfxnE=";
  };

  cargoHash = "sha256-zZ/xE7DVX1HSK81xwB4VxCtnOTUwJvSScmJeA/t/ACI=";

  meta = with lib; {
    description = "Small command-line JSON log viewer";
    mainProgram = "fblog";
    homepage = "https://github.com/brocode/fblog";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ figsoda ];
  };
}

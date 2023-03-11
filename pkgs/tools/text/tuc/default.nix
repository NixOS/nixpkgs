{ lib, fetchFromGitHub, rustPlatform }:
rustPlatform.buildRustPackage rec {
  pname = "tuc";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "riquito";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zEWQ1wGpEowVPdlezC/LZhoPGS546nuqREfavo3fbTs=";
  };

  cargoHash = "sha256-YRw1HxVy1/SOWfareR6rh6M78xFm+Im//klhXGGt95g=";

  meta = with lib; {
    description = "When cut doesn't cut it";
    homepage = "https://github.com/riquito/tuc";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dit7ya ];
  };
}

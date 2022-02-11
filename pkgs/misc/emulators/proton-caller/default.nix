{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "proton-caller";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "caverym";
    repo = pname;
    rev = version;
    sha256 = "sha256-k+cH86atuVoLCQ+I1zu08f4T+y0u8vnjo3VA+Otg+a4=";
  };

  cargoSha256 = "sha256-rkgg96IdIhVXZ5y/ECUxNPyPV9Nv5XGAtlxAkILry2s=";

  meta = with lib; {
    description = "Run Windows programs with Proton";
    changelog = "https://github.com/caverym/proton-caller/releases/tag/${version}";
    homepage = "https://github.com/caverym/proton-caller";
    license = licenses.mit;
    maintainers = with maintainers; [ kho-dialga ];
  };
}

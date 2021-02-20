{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "emplace";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "tversteeg";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-FO3N5Dyk87GzPEhQDX2QVDulw15BnpsljawY2RFy2Qk=";
  };

  cargoSha256 = "sha256-/XZ88ChOCLP5/pZ9UkAAWqO/jFUwbo5FJQ2GZip1gP4=";

  meta = with lib; {
    description = "Mirror installed software on multiple machines";
    homepage = "https://github.com/tversteeg/emplace";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}

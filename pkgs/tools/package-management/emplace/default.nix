{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "emplace";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "tversteeg";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-02Pn5saPrw1PIFZXVSCgsnvo/78CdT17/rCtS9R9bvU=";
  };

  cargoSha256 = "sha256-ety50v0jxm45fzzkR9c/rvpJn3mWQUvAOHcHSJTTSd4=";

  meta = with lib; {
    description = "Mirror installed software on multiple machines";
    homepage = "https://github.com/tversteeg/emplace";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}

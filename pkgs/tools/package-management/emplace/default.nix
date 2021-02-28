{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "emplace";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "tversteeg";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vA+Y4j9Flcrizqh61+4X70FzF5/wK2WVHQRsAUQzKnU=";
  };

  cargoSha256 = "sha256-zGdjMpB7h+/RdM+wXffUuAyHnks6umyJmzUrANmqAS8=";

  meta = with lib; {
    description = "Mirror installed software on multiple machines";
    homepage = "https://github.com/tversteeg/emplace";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}

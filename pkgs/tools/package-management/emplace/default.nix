{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "emplace";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "tversteeg";
    repo = pname;
    rev = "v${version}";
    sha256 = "0dkdgb0hbaixc69yh75lq4lamvgd421lk1v7qn802h83fibcmh81";
  };

  cargoSha256 = "10y7lpgj9mxrh3rmc15km4rfzspwdjr8dcdh0747rjn6dcpfhcdq";

  meta = with lib; {
    description = "Mirror installed software on multiple machines";
    homepage = "https://github.com/tversteeg/emplace";
    license = licenses.agpl3;
    maintainers = with maintainers; [ filalex77 ];
    platforms = platforms.all;
  };
}

{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "emplace";
  version = "0.2.10";

  src = fetchFromGitHub {
    owner = "tversteeg";
    repo = pname;
    rev = "v${version}";
    sha256 = "1y77cla6bgy8pjb21cawx7cb69hhri4r7gyjkhnjyiixkh945mwj";
  };

  cargoSha256 = "1vkcr239axxqya0iin74jxkmx6z9nwb67pjjdh89v4qwjvwhiqg3";

  meta = with lib; {
    description = "Mirror installed software on multiple machines";
    homepage = "https://github.com/tversteeg/emplace";
    license = licenses.agpl3;
    maintainers = with maintainers; [ filalex77 ];
    platforms = platforms.all;
  };
}

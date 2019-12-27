{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "emplace";
  version = "0.2.9";

  src = fetchFromGitHub {
    owner = "tversteeg";
    repo = pname;
    rev = "v${version}";
    sha256 = "01snlgpqa5khnnkv8idm6xdwr42pqg3bqp92vvggqxn17n3fd8kn";
  };

  cargoSha256 = "0q7y9wa7fi0j71mxlcfxfijpccjfyazp5ipsnaj28r9mj1c6lkis";

  meta = with lib; {
    description = "Mirror installed software on multiple machines";
    homepage = "https://github.com/tversteeg/emplace";
    license = licenses.agpl3;
    maintainers = with maintainers; [ filalex77 ];
    platforms = platforms.all;
  };
}

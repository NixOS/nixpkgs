{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "emplace";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "tversteeg";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ys61wfga7kakfhq2b7yk2ygp8ffar43w4bfa6g483dq7ysqi5hl";
  };

  cargoSha256 = "07336a5xrc7kwgkasl42g1sqad35v0dmpmv1hxr1w5j1wpggw3bj";

  meta = with lib; {
    description = "Mirror installed software on multiple machines";
    homepage = "https://github.com/tversteeg/emplace";
    license = licenses.agpl3;
    maintainers = with maintainers; [ filalex77 ];
    platforms = platforms.all;
  };
}

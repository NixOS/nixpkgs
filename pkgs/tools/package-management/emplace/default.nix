{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "emplace";
  version = "0.3.8";

  src = fetchFromGitHub {
    owner = "tversteeg";
    repo = pname;
    rev = "v${version}";
    sha256 = "1g7xrsw0ji3nbrj1a2hywxwy7f33fgbvzp7k4l9ls2icg0xsw9a3";
  };

  cargoSha256 = "1phr0k05dxwdhj1i71v8lr91qanjvp2zgi9wjpppzixpnpcsrbrb";

  meta = with lib; {
    description = "Mirror installed software on multiple machines";
    homepage = "https://github.com/tversteeg/emplace";
    license = licenses.agpl3;
    maintainers = with maintainers; [ filalex77 ];
  };
}

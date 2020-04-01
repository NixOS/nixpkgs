{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "emplace";
  version = "0.2.14";

  src = fetchFromGitHub {
    owner = "tversteeg";
    repo = pname;
    rev = "v${version}";
    sha256 = "0fkagz215clg7hikjqni8c9wqb3s0szyjr55f2w8zd6zpmvcs1n5";
  };

  cargoSha256 = "0fsrv2cak0zawg448jfbgzbaimn8pvw15xrb5x4733axlkg4g1ch";

  meta = with lib; {
    description = "Mirror installed software on multiple machines";
    homepage = "https://github.com/tversteeg/emplace";
    license = licenses.agpl3;
    maintainers = with maintainers; [ filalex77 ];
    platforms = platforms.all;
  };
}

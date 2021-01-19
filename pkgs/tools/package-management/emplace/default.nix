{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "emplace";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "tversteeg";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-iPfE2z98j93zqK2uZ8R+Fy2qNOCH9oCxHgeedvs/onY=";
  };

  cargoSha256 = "sha256-62DHIIwloB+pPAZnOEfLJzAWrRJSxPp4IghBh6lRuc8=";

  meta = with lib; {
    description = "Mirror installed software on multiple machines";
    homepage = "https://github.com/tversteeg/emplace";
    license = licenses.agpl3;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}

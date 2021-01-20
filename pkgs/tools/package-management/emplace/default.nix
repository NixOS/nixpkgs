{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "emplace";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "tversteeg";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-74jv5GvBSErU5qjd4QmAK4JZhqFoqBf3cNxOGLIqt9U=";
  };

  cargoSha256 = "sha256-SPHXkvtUL6hdYOE1fUIQLEqWzn68RVBiu6zJQJ/3BxQ=";

  meta = with lib; {
    description = "Mirror installed software on multiple machines";
    homepage = "https://github.com/tversteeg/emplace";
    license = licenses.agpl3;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}

{
  lib,
  rustPlatform,
  fetchFromGitLab,
}:

rustPlatform.buildRustPackage rec {
  pname = "watchlog";
  version = "1.152.0";

  src = fetchFromGitLab {
    owner = "kevincox";
    repo = "watchlog";
    rev = "v${version}";
    sha256 = "sha256-m0sqLi5qxQKfdFtHxo0DX4bV6lUNZP1JWt8NAfY+F5A=";
  };

  cargoSha256 = "sha256-uIaGIHBB/ntGyBZL45E61E9fELR8UGRieb/fJQsB5NE=";

  meta = {
    description = "Easier monitoring of live logs";
    homepage = "https://gitlab.com/kevincox/watchlog";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kevincox ];

    # Dependency only supports Linux + Windows: https://github.com/mentaljam/standard_paths/tree/master/src
    platforms = with lib.platforms; linux ++ windows;
  };
}

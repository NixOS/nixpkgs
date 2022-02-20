{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "shiori";
  version = "1.5.1";

  vendorSha256 = "sha256-6XF4wBwoRnINAskhGHTw4eAJ9zAaoZcEYo9/xZk4ems=";

  doCheck = false;

  src = fetchFromGitHub {
    owner = "go-shiori";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ulq2Uy0NFzGTIHqbA/LiUaXzlYYPbswDm9uiLYzxx+k=";
  };

  meta = with lib; {
    description = "Simple bookmark manager built with Go";
    homepage = "https://github.com/go-shiori/shiori";
    license = licenses.mit;
    maintainers = with maintainers; [ minijackson ];
  };
}

{ lib, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "babelfish";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "bouk";
    repo = "babelfish";
    rev = "v${version}";
    sha256 = "sha256-/rWX77n9wqWxkHG7gVOinCJ6ahuEfbAcGijC1oAxrno=";
  };

  vendorSha256 = "sha256-HY9ejLfT6gj3vUMSzbNZ4QlpB+liigTtNDBNWCy8X38=";

  meta = with lib; {
    description = "Translate bash scripts to fish";
    homepage = "https://github.com/bouk/babelfish";
    license = licenses.mit;
    maintainers = with maintainers; [ bouk kevingriffin ];
  };
}

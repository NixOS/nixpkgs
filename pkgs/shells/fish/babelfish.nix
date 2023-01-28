{ lib, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "babelfish";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "bouk";
    repo = "babelfish";
    rev = "v${version}";
    sha256 = "0b1knj9llwzwnl4w3d6akvlc57dp0fszjkq98w8wybcvkbpd3ip1";
  };

  vendorSha256 = "0kspqwbgiqfkfj9a9pdwzc0jdi9p35abqqqjhcpvqwdxw378w5lz";

  meta = with lib; {
    description = "Translate bash scripts to fish";
    homepage = "https://github.com/bouk/babelfish";
    license = licenses.mit;
    maintainers = with maintainers; [ bouk kevingriffin ];
  };
}

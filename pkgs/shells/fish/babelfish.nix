{ lib, stdenv, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "babelfish";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "bouk";
    repo = "babelfish";
    rev = "v${version}";
    sha256 = "A5FUnER25FDkL/K7RCqudZI6Xd5wg9B8aLbYUw6+7BA=";
  };

  vendorSha256 = "T70gnmmR4yBwY2ZCiIR35LIbFYSnTRvwTGLwyDgoXnY=";

  meta = with lib; {
    description = "Translate bash scripts to fish";
    homepage = "https://github.com/bouk/babelfish";
    license = licenses.mit;
    maintainers = with maintainers; [ bouk kevingriffin ];
  };
}

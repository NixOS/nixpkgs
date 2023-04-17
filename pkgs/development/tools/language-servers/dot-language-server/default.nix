{ lib, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "dot-language-server";
  version = "1.1.26";

  src = fetchFromGitHub {
    owner = "nikeee";
    repo = "dot-language-server";
    rev = "v${version}";
    hash = "sha256-Wv+Bw+mcc4vn1CfjIy5vAg5Kw7TUf+flcqLguvQVaCQ=";
  };

  npmDepsHash = "sha256-w7c6f+VlBx2kvLyEWgbT9S0hA7mu5gCNuQzGThkXAGY=";

  npmBuildScript = "compile";

  meta = with lib; {
    description = "A language server for the DOT language";
    homepage = "https://github.com/nikeee/dot-language-server";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}

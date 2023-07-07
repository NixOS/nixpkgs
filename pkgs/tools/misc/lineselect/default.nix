{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "lineselect";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "chfritz";
    repo = "lineselect";
    rev = "v${version}";
    hash = "sha256-qEAfXBqIuEJ7JPowEJrmo2+xSrLRfhfktAd1Q7NDnAI=";
  };

  npmDepsHash = "sha256-y4J/EuOHVQHDCId6WTcphNY4LxMyNIGkXeEUoHRaYos=";

  meta = with lib; {
    description = "Shell utility to interactively select lines from stdin";
    homepage = "https://github.com/chfritz/lineselect";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}

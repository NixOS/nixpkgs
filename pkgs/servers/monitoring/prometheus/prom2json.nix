{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "prom2json";
  version = "1.4.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "prometheus";
    repo = "prom2json";
    sha256 = "sha256-cKz+ZFQYjsL7dFfXXCrl4T8OuvQkdqVAotG9HRNtN7o=";
  };

  vendorHash = "sha256-pCy4oECZnvoODezUD1+lOT46yWUr78zvnHgEB2BJN3c=";

  meta = with lib; {
    description = "Tool to scrape a Prometheus client and dump the result as JSON";
    mainProgram = "prom2json";
    homepage = "https://github.com/prometheus/prom2json";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
  };
}

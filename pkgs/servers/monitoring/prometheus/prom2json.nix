{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "prom2json";
  version = "1.3.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "prometheus";
    repo = "prom2json";
    sha256 = "sha256-5RPpgUEFLecu0qRg7KSNLwdUEiXeebrGdP/udCtq4z0=";
  };

  vendorSha256 = "sha256-fPGkqrnl21as1xiT279qPzkz01tDNOSMcsm/DSNHDU0=";

  meta = with lib; {
    description = "Tool to scrape a Prometheus client and dump the result as JSON";
    homepage = "https://github.com/prometheus/prom2json";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}

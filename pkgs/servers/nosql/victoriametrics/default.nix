{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "VictoriaMetrics";
  version = "1.33.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1irc3zahp72631ai9rafc8n7vayr4hzlh8qla05chlsb2fwzqrrd";
  };

  modSha256 = "0qzh3jmj7ps6xmnnmfr8bnq97kdkn58p6dxppmlypanar3zsn7vk";
  meta = with lib; {
    homepage = "https://victoriametrics.com/";
    description = "fast, cost-effective and scalable time series database, long-term remote storage for Prometheus";
    license = licenses.asl20;
    maintainers = [ maintainers.yorickvp ];
  };
}

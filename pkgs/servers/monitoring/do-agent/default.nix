{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  name = "do-agent-${version}";
  version = "3.5.6";

  src = fetchFromGitHub {
    owner = "digitalocean";
    repo = "do-agent";
    rev = "${version}";
    sha256 = "1gl034cslqa30fqy2p9rymgx398s1rcgbmfvzk5zjlrw47327k8i";
  };

  buildFlagsArray = ''
    -ldflags=
      -X main.version=${version}
  '';

  modSha256 = "0ydjwxdkcz0blpzwapiaq66vh7nrcg4j91z6h7v4ynnw2rgp7pmy";

  meta = with lib; {
    description = ''
      Collects system metrics from a DigitalOcean Droplet (on which the program
      runs) and sends them to DigitalOcean
    '';
    homepage = https://github.com/digitalocean/do-agent;
    license = licenses.asl20;
    maintainers = with maintainers; [ yvt ];
    platforms = platforms.linux;
  };
}

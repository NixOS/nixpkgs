{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "do-agent";
  version = "3.11.0";

  src = fetchFromGitHub {
    owner = "digitalocean";
    repo = "do-agent";
    rev = version;
    sha256 = "sha256-Up7HBG6h24XIjBRvQYZpuB5lWXYTipQql9loykwwd1k=";
  };

  ldflags = [
    "-X main.version=${version}"
  ];

  vendorSha256 = null;

  doCheck = false;

  postInstall = ''
    install -Dm444 -t $out/lib/systemd/system $src/packaging/etc/systemd/system/do-agent.service
  '';

  meta = with lib; {
    description = "DigitalOcean droplet system metrics agent";
    longDescription = ''
      do-agent is a program provided by DigitalOcean that collects system
      metrics from a DigitalOcean Droplet (on which the program runs) and sends
      them to DigitalOcean to provide resource usage graphs and alerting.
    '';
    homepage = "https://github.com/digitalocean/do-agent";
    license = licenses.asl20;
    maintainers = with maintainers; [ yvt ];
    platforms = platforms.linux;
  };
}

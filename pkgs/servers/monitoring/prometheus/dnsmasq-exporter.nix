{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dnsmasq_exporter";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "dnsmasq_exporter";
    sha256 = "1i7imid981l0a9k8lqyr9igm3qkk92kid4xzadkwry4857k6mgpj";
    rev = "v${version}";
  };

  modSha256 = "1ag1k0z35zkazaxj8hh2wxfj73xg63xdybfm1565il2vxs5986dh";

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "A dnsmasq exporter for Prometheus";
    license = licenses.asl20;
    maintainers = with maintainers; [ willibutz globin ma27 ];
  };
}

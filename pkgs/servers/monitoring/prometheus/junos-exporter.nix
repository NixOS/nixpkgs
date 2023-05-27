{ lib, buildGoModule, fetchFromGitHub, net-snmp, nixosTests }:

buildGoModule rec {
  pname = "junos_exporter";
  version = "0.9.10";

  src = fetchFromGitHub {
    owner = "czerwonk";
    repo = "junos_exporter";
    rev = version;
    sha256 = "0yi8yxwgcc129yi29w6mq03yri2n3aa5fcg578ly2krnqs55x624";
  };

  vendorSha256 = "082cj25jfrkjihs76i1zdbfyb2096ihkdasw04w5008ab51j9016";

  doCheck = true;

  meta = with lib; {
    description = "Exporter for metrics from devices running JunOS (via SSH)";
    homepage = "https://github.com/czerwonk/junos_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ arezvov ];
    platforms = platforms.unix;
  };
}

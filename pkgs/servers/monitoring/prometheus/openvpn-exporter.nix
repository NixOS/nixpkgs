{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "openvpn_exporter-unstable";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "kumina";
    repo = "openvpn_exporter";
    rev = "v${version}";
    sha256 = "14m4n5918zimdnyf0yg2948jb1hp1bdf27k07j07x3yrx357i05l";
  };

  vendorSha256 = "1jgw0nnibydhcd83kp6jqkf41mhwldp8wdhqk0yjw18v9m0p7g5s";

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Prometheus exporter for OpenVPN";
    broken = true;
    license = licenses.asl20;
    maintainers = with maintainers; [ globin ];
  };
}

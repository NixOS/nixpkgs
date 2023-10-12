{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "openvpn_exporter-unstable";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "kumina";
    repo = "openvpn_exporter";
    rev = "v${version}";
    hash = "sha256-tIB4yujZj36APGAe4doKF4YlEUnieeC8bTV+FFKxpJI=";
  };

  vendorHash = "sha256-urxzQU0bBS49mBg2jm6jHNZA3MTS3DlQY7D5Fa0F/Mk=";

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Prometheus exporter for OpenVPN";
    broken = true;
    license = licenses.asl20;
    maintainers = with maintainers; [ globin ];
  };
}

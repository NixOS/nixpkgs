{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "emplace";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "tversteeg";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Qx989u2893Jv4/ZUdSqZk+q/FUjo0GDoVzeS63AO2HA=";
  };

  cargoSha256 = "sha256-s0RIEZw8FOdKqMXgDPNXmqp7V6flzE8eF1J/rSK+qKs=";

  meta = with lib; {
    description = "Mirror installed software on multiple machines";
    homepage = "https://github.com/tversteeg/emplace";
    license = licenses.agpl3;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}

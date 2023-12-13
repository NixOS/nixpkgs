{ lib
, buildGoModule
, fetchFromGitHub
, libpcap
}:

buildGoModule rec {
  pname = "dnsmon-go";
  version = "unstable-2022-05-13";

  src = fetchFromGitHub {
    owner = "jonpulsifer";
    repo = pname;
    rev = "ec1d59f1f1314ce310ad4c04d2924e0ebd857f1d";
    hash = "sha256-lAJ2bjs5VLzrHd09eFK4X0V/cCee2QsgdgiKq+y2c10=";
  };

  vendorHash = "sha256-aiX+NGUsFK0N9vC5baAHHMr28CbF5Xa4WgYLFFLBYTs=";

  buildInputs = [
    libpcap
  ];

  meta = with lib; {
    description = "Tool to collect DNS traffic";
    homepage = "https://github.com/jonpulsifer/dnsmon-go";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

{
  fetchFromGitHub,
  buildGoModule,
  lib,
}:

buildGoModule rec {
  pname = "traefik-certs-dumper";
  version = "2.8.3";

  src = fetchFromGitHub {
    owner = "ldez";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dSVtowebmDA0X/PtLKktvb1+FhQ+evMoxFBXIXqZujw=";
  };

  vendorHash = "sha256-a23kTtjIaMYs3+S9rYZ6ttyCyyK6Wm2wUZQw+In/hG4=";
  excludedPackages = "integrationtest";

  meta = with lib; {
    description = "dump ACME data from traefik to certificates";
    homepage = "https://github.com/ldez/traefik-certs-dumper";
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
    mainProgram = "traefik-certs-dumper";
  };
}

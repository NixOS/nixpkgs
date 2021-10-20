{ fetchFromGitHub, buildGoModule, lib }:

buildGoModule rec {
  pname = "traefik-certs-dumper";
  version = "2.7.4";

  src = fetchFromGitHub {
    owner = "ldez";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-exkBDrNGvpOz/VD6yfE1PKL4hzs/oZ+RxMwm/ytuV/0=";
  };

  vendorSha256 = "sha256-NmYfdX5BKHZvFzlkh/kkK0voOzNj1EPn53Mz/B7eLd0=";
  excludedPackages = "integrationtest";

  meta = with lib; {
    description = "dump ACME data from traefik to certificates";
    homepage = "https://github.com/ldez/traefik-certs-dumper";
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
  };
}

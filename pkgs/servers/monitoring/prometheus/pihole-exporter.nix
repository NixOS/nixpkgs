{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pihole-exporter";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "eko";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-LtiJpXucD9Ok1tFFCQ5/V6FhYxbgBWDPF6S49FzWPes=";
  };

  vendorSha256 = "sha256-GCHCWnP3YPC1Dg8Tu0GF5ITDMVRoBv28QVpk6JGN5nQ=";

  meta = with lib; {
    description = "Prometheus exporter for PI-Hole's Raspberry PI ad blocker";
    homepage = "https://github.com/eko/pihole-exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}

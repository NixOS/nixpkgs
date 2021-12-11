{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "kepubify";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "pgaskin";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-w48ln6xlxdUVMdLuprtnAx36liC8QuXAaJpOfnpv9AM=";
  };

  vendorSha256 = "sha256-gCdCAlJ5h40zi3w1S6NZZVB2iEx4F7cVLDn4pOr9JWA=";

  # remove when built with >= go 1.17
  tags = [ "zip117" ];

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  excludedPackages = [ "kobotest" ];

  meta = with lib; {
    description = "EPUB to KEPUB converter";
    homepage = "https://pgaskin.net/kepubify";
    license = licenses.mit;
    maintainers = with maintainers; [ zowoq ];
  };
}

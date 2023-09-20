{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gotests";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "cweill";
    repo = "gotests";
    rev = "v${version}";
    sha256 = "sha256-6IzUpAsFUgF2FwiC17OfDn1M+8WYFQPpRyXbkpHIztw=";
  };

  vendorHash = "sha256-WMeHZN3s+8pIYEVaSLjI3Bz+rPTWHr1AkZ8lydjBwCw=";

  # tests are broken in nix environment
  doCheck = false;

  meta = with lib; {
    description = "Generate Go tests from your source code";
    homepage = "https://github.com/cweill/gotests";
    maintainers = with maintainers; [ vdemeester ];
    license = licenses.asl20;
  };
}

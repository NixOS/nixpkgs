{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "dnsproxy";
  version = "0.37.7";

  src = fetchFromGitHub {
    owner = "AdguardTeam";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5/ggeNBMNlwX6AzYO0haAU18xY0rYpELts6lqZmJxj4=";
  };

  vendorSha256 = null;

  doCheck = false;

  meta = with lib; {
    description = "Simple DNS proxy with DoH, DoT, and DNSCrypt support";
    homepage = "https://github.com/AdguardTeam/dnsproxy";
    license = licenses.gpl3;
    maintainers = with maintainers; [ contrun ];
  };
}

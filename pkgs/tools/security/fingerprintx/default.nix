{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "fingerprintx";
  version = "1.1.10";

  src = fetchFromGitHub {
    owner = "praetorian-inc";
    repo = "fingerprintx";
    rev = "refs/tags/v${version}";
    hash = "sha256-WwIIZlO310519aEPpvi3pY2Jn3HRNUZNiwoAyZ4VP1A=";
  };

  vendorHash = "sha256-TMy6FwAFlo+ARvm+RiRqly0xIk4lBCXuZrtdnNSMSxw=";

  ldflags = [
    "-s"
    "-w"
  ];

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Standalone utility for service discovery on open ports";
    homepage = "https://github.com/praetorian-inc/fingerprintx";
    changelog = "https://github.com/praetorian-inc/fingerprintx/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}

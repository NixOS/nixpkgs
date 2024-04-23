{ lib, buildGoModule, fetchFromGitHub, testers, dnscrypt-proxy }:

buildGoModule rec {
  pname = "dnscrypt-proxy";
  version = "2.1.5";

  vendorHash = null;

  doCheck = false;

  src = fetchFromGitHub {
    owner = "DNSCrypt";
    repo = "dnscrypt-proxy";
    rev = version;
    sha256 = "sha256-A9Cu4wcJxrptd9CpgXw4eyMX2nmNAogYBRDeeAjpEZY=";
  };

  passthru.tests.version = testers.testVersion {
    package = dnscrypt-proxy;
  };

  meta = with lib; {
    description = "A tool that provides secure DNS resolution";

    license = licenses.isc;
    homepage = "https://dnscrypt.info/";
    maintainers = with maintainers; [ atemu waynr ];
    mainProgram = "dnscrypt-proxy";
    platforms = with platforms; unix;
  };
}

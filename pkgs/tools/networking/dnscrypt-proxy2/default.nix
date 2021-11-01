{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dnscrypt-proxy2";
  version = "2.1.1";

  vendorSha256 = null;

  doCheck = false;

  src = fetchFromGitHub {
    owner = "DNSCrypt";
    repo = "dnscrypt-proxy";
    rev = version;
    sha256 = "sha256-BtH/h2HejXDWSoqWRTjZXMLYDRoMe8lSUDX6Gay1gA8=";
  };

  meta = with lib; {
    description = "A tool that provides secure DNS resolution";

    license = licenses.isc;
    homepage = "https://dnscrypt.info/";
    maintainers = with maintainers; [ atemu waynr ];
    platforms = with platforms; unix;
  };
}

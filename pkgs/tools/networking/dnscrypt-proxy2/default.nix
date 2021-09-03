{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dnscrypt-proxy2";
  version = "2.1.0";

  vendorSha256 = null;

  doCheck = false;

  src = fetchFromGitHub {
    owner = "DNSCrypt";
    repo = "dnscrypt-proxy";
    rev = version;
    sha256 = "sha256-HU5iy1dJbCp/PHnJjLi6MM+axz5Nrlcad5GEkD2p874=";
  };

  meta = with lib; {
    description = "A tool that provides secure DNS resolution";

    license = licenses.isc;
    homepage = "https://dnscrypt.info/";
    maintainers = with maintainers; [ atemu waynr ];
    platforms = with platforms; unix;
  };
}

{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "hologram";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "AdRoll";
    repo = "hologram";
    rev = version;
    sha256 = "sha256-rdV/oVo+M5ALyU3a3XlA4kt+TLg0Rnr7/qDyZ9iuIb4=";
  };

  postPatch = ''
    sed -i 's|cacheTimeout != 3600|cacheTimeout != 0|' cmd/hologram-server/main.go

    rm -f agent/metadata_service_test.go server/persistent_ldap_test.go server/server_test.go
  '';

  vendorSha256 = "sha256-pEYMpBiNbq5eSDiFT+9gMjGHDeTzWIej802Zz6Xtays=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://github.com/AdRoll/hologram/";
    description = "Easy, painless AWS credentials on developer laptops";
    maintainers = with maintainers; [ ];
    license = licenses.asl20;
  };
}

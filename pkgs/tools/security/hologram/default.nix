{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "hologram";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "AdRoll";
    repo = "hologram";
    rev = version;
    hash = "sha256-b65mplfDuwk8lEfJLKBY7BF0yGRksxHjwbEW6A7moo4=";
  };

  postPatch = ''
    sed -i 's|cacheTimeout != 3600|cacheTimeout != 0|' cmd/hologram-server/main.go

    rm -f agent/metadata_service_test.go server/persistent_ldap_test.go server/server_test.go
  '';

  vendorHash = "sha256-HI5+02qSQVLy6ZKaFjy1bWtvVk5bqMBg1umu2ic5HuY=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://github.com/AdRoll/hologram/";
    description = "Easy, painless AWS credentials on developer laptops";
    maintainers = with maintainers; [ aaronjheng ];
    license = licenses.asl20;
  };
}

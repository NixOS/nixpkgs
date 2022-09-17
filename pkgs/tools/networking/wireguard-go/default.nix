{ lib, buildGoModule, fetchzip, testers, wireguard-go }:

buildGoModule rec {
  pname = "wireguard-go";
  version = "0.0.20220316";

  src = fetchzip {
    url = "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-${version}.tar.xz";
    sha256 = "sha256-OQiG92idGwOXWX4H4HNmk2dmRM2+GtssJFzavhj1HxM=";
  };

  postPatch = ''
    # Skip formatting tests
    rm -f format_test.go
  '';

  vendorSha256 = "sha256-MrHkOj0YfvAm8zOowXzl23F1NPTCO0F8vMMGT/Y+nQ0=";

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" ];

  postInstall = ''
    mv $out/bin/wireguard $out/bin/wireguard-go
  '';

  passthru.tests.version = testers.testVersion {
    package = wireguard-go;
    version = "v${version}";
  };

  meta = with lib; {
    description = "Userspace Go implementation of WireGuard";
    homepage = "https://git.zx2c4.com/wireguard-go/about/";
    license = licenses.mit;
    maintainers = with maintainers; [ kirelagin yana zx2c4 ];
  };
}

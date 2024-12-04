{ lib, buildGoModule, fetchzip, testers, wireguard-go }:

buildGoModule rec {
  pname = "wireguard-go";
  version = "0.0.20230223";

  src = fetchzip {
    url = "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-${version}.tar.xz";
    sha256 = "sha256-ZVWbZwSpxQvxwySS3cfzdRReFtHWk6LT2AuIe10hyz0=";
  };

  postPatch = ''
    # Skip formatting tests
    rm -f format_test.go
  '';

  vendorHash = "sha256-i6ncA71R0hi1SzqCLphhtF3yRAHDmOdYJQ6pf3UDBg8=";

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
    maintainers = with maintainers; [ kirelagin zx2c4 ];
    mainProgram = "wireguard-go";
  };
}

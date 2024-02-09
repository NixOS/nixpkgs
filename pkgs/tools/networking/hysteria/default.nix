{ lib
, fetchFromGitHub
, buildGoModule
}:
buildGoModule rec {
  pname = "hysteria";
  version = "2.2.4";

  src = fetchFromGitHub {
    owner = "apernet";
    repo = pname;
    rev = "app/v${version}";
    hash = "sha256-A8UTnvH5BYRETsjte65+M+HHO6MrqCiPthNEYwBkBYs=";
  };

  vendorHash = "sha256-uh/qYQBWsyazSbJIz1ykf5bap18fGSIfjVDL8zus2l0=";
  proxyVendor = true;

  ldflags =
    let cmd = "github.com/apernet/hysteria/app/cmd";
    in [
      "-s"
      "-w"
      "-X ${cmd}.appVersion=${version}"
      "-X ${cmd}.appType=release"
    ];

  postInstall = ''
    mv $out/bin/app $out/bin/hysteria
  '';

  # Network required
  doCheck = false;

  meta = with lib; {
    description = "A feature-packed proxy & relay utility optimized for lossy, unstable connections";
    homepage = "https://github.com/apernet/hysteria";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ oluceps ];
  };
}

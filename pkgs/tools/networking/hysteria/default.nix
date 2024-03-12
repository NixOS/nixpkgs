{ lib
, fetchFromGitHub
, buildGoModule
}:
buildGoModule rec {
  pname = "hysteria";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "apernet";
    repo = pname;
    rev = "app/v${version}";
    hash = "sha256-sjQrHvUdGPdzKpXuJ9ZWp4S9pram8QaygKLT2WRmd2M=";
  };

  vendorHash = "sha256-btDWsvhKygWda4x45c8MSOROq6ujJVV9l0PkGQKWM6A=";
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
    mainProgram = "hysteria";
  };
}

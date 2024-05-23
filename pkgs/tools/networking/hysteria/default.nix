{ lib
, fetchFromGitHub
, buildGoModule
}:
buildGoModule rec {
  pname = "hysteria";
  version = "2.4.4";

  src = fetchFromGitHub {
    owner = "apernet";
    repo = pname;
    rev = "app/v${version}";
    hash = "sha256-p6h9cZYSxyMgLaVASnbHk6Bjdt6tTqj/9vhTS/CaiWA=";
  };

  vendorHash = "sha256-DiwF8QuEs5JaSL+G6aycW01bXnQtL/GTd5kYsYeJUD4=";
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

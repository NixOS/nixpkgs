{ lib
, fetchFromGitHub
, buildGoModule
}:
buildGoModule rec {
  pname = "hysteria";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "apernet";
    repo = pname;
    rev = "app/v${version}";
    hash = "sha256-MMBDBWeOm0yiKNGe/Ywriv8oR0YoM3Or5uGGuePOV3U=";
  };

  vendorHash = "sha256-zsPqqk8nKhtF2RXfF2yRhienzLMLPAcHQgnEX8gcl3s=";
  proxyVendor = true;

  ldflags = [
    "-s"
    "-w"
    "-X main.appVersion=${version}"
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
    platforms = platforms.linux;
    maintainers = with maintainers; [ oluceps ];
  };
}

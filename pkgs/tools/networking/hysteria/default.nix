{ lib
, fetchFromGitHub
, buildGoModule
}:
buildGoModule rec {
  pname = "hysteria";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "apernet";
    repo = pname;
    rev = "e11762a196e4fcdbde728ef160bc3c6cfeb5bc6e";
    hash = "sha256-9Fo/qKcoZg8OYH4cok18rweA1PAFULOCJGTdUB8fbAU=";
  };

  vendorHash = "sha256-7un8oi6pKYiJGw6mbG35crndLg35y7VkoAnQKMJduh4=";
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

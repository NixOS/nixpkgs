{ lib
, fetchFromGitHub
, buildGo121Module
}:
buildGo121Module rec {
  pname = "hysteria";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "apernet";
    repo = pname;
    rev = "app/v${version}";
    hash = "sha256-CvhDOtXyGxnTy8m7qN5lmQxOxwkExfW+1ZT3LrLjsmo=";
  };

  vendorHash = "sha256-Io7EN+Cza7drMLB9JF4nRDxq+eVxW5sYj45WWvXtDsY=";
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

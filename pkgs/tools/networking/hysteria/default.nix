{ lib
, fetchFromGitHub
, buildGo121Module
}:
buildGo121Module rec {
  pname = "hysteria";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "apernet";
    repo = pname;
    rev = "app/v${version}";
    hash = "sha256-0ekw92T9yWrKu5MxSssOCXlUFubiVLoH6ZLEMDFkcis=";
  };

  vendorHash = "sha256-Hf+Jx/z+hJ6jqWLJHGK7umNgNzNKYgQtCdAosdrqvPg=";
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

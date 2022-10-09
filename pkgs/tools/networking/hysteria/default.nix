{ lib
, fetchFromGitHub
, buildGoModule
}:
buildGoModule rec {
  pname = "hysteria";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "HyNetwork";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-xL8xRVJdCyaP39TO+cJLAPbdc7WHxgBQMEyxkyhWlA8=";
  };

  vendorSha256 = "sha256-VCQHkkYmGU0ZPmTuYu2XFa5ezDJ3x7dZGN+Usmq4sOY=";
  proxyVendor = true;

  ldflags = [
    "-s"
    "-w"
    "-X main.appVersion=${version}"
    "-X main.appCommit=${version}"
  ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/hysteria
  '';

  # Network required
  doCheck = false;

  meta = with lib; {
    description = "A feature-packed proxy & relay utility optimized for lossy, unstable connections";
    homepage = "https://github.com/HyNetwork/hysteria";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ oluceps ];
  };
}

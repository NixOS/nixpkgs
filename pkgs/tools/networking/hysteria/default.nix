{ lib
, fetchFromGitHub
, buildGoModule
}:
buildGoModule rec {
  pname = "hysteria";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "HyNetwork";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XAf835p2a7ThGgYL62pcEWqjp0rs/cRYfzTJsV6j2oA=";
  };

  vendorSha256 = "sha256-nVUS3KquKUSN/8OHPlcMK9gDJmrxvWS8nHYE7m6hZPQ=";
  proxyVendor = true;

  ldflags = [
    "-s"
    "-w"
    "-X main.appVersion=${version}"
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

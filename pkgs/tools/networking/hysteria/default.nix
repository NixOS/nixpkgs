{ lib
, fetchFromGitHub
, buildGoModule
}:
buildGoModule rec {
  pname = "hysteria";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "HyNetwork";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-CQgCFtvQDvhHTk10gpxfAvEJLz/i+CXXyzGrxi26hBk=";
  };

  vendorSha256 = "sha256-sN+2XYoC+dDs6QKxwxuBCW4dOf4elSNKdOrbMxjOtSY=";
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

{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "clash-meta";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "MetaCubeX";
    repo = "Clash.Meta";
    rev = "v${version}";
    sha256 = "sha256-Im+vn3uLSAOq6dDe39g3y/mBqybaK2aG4XJnBp3IuUs=";
  };

  vendorSha256 = "sha256-U74HCUSZv7sYVp1G8Xokp8tvUGVQXhfp5plcW4G7/ww=";

  # Do not build testing suit
  excludedPackages = ["./test"];

  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/Dreamacro/clash/constant.Version=${version}"
  ];

  meta = with lib; {
    description = "Another Clash Kernel";
    homepage = "https://github.com/MetaCubeX/Clash.Meta";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [oluceps];
  };
}

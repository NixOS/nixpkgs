{ lib
, fetchFromGitHub
, buildGoModule
}:
buildGoModule rec {
  pname = "clash-meta";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "MetaCubeX";
    repo = "Clash.Meta";
    rev = "v${version}";
    hash = "sha256-QXNMplVy4cDRbUUDwidto7jxgjStX5PmCLdAIW7Edn8=";
  };

  vendorHash = "sha256-lMeJ3z/iTHIbJI5kTzkQjNPMv5tGMJK/+PM36BUlpjE=";

  # Do not build testing suit
  excludedPackages = [ "./test" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/Dreamacro/clash/constant.Version=${version}"
  ];

  tags = [
    "with_gvisor"
  ];

  # network required
  doCheck = false;

  postInstall = ''
    mv $out/bin/clash $out/bin/clash-meta
  '';

  meta = with lib; {
    description = "Another Clash Kernel";
    homepage = "https://github.com/MetaCubeX/Clash.Meta";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ oluceps ];
    mainProgram = "clash-meta";
  };
}

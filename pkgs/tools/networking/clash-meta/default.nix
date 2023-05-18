{ lib
, fetchFromGitHub
, buildGoModule
}:
buildGoModule rec {
  pname = "clash-meta";
  version = "1.14.4";

  src = fetchFromGitHub {
    owner = "MetaCubeX";
    repo = "Clash.Meta";
    rev = "v${version}";
    # macOS has a case-insensitive filesystem, so these two can be the same file
    postFetch = ''
      rm -f $out/.github/workflows/{Delete,delete}.yml
    '';
    hash = "sha256-HEJQaNFKcmR7KtXsYs2h1KpRZJfQljYjMUBMdqg7gRU=";
  };

  vendorHash = "sha256-jvl4dAP0EOl9p/3LPNLUqzg8H/mP7AKaI+lJ6ROo/1k=";

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
  };
}

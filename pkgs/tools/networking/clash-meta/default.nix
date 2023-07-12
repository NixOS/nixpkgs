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
    # macOS has a case-insensitive filesystem, so these two can be the same file
    postFetch = ''
      rm -f $out/.github/workflows/{Delete,delete}.yml
    '';
    hash = "sha256-trufMtk3t9jA6hc9CenHsd3k41nrCyJYyOuHzzWv+Jw=";
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
  };
}

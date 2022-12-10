{ lib
, buildGoModule
, fetchFromGitHub
, buildNpmPackage
}:
let
  version = "0.3.5";
  src = fetchFromGitHub {
    owner = "zinclabs";
    repo = "zinc";
    rev = "v${version}";
    sha256 = "sha256-qu3foI5Rnt2sf+B+roJOwUNvOfawKmcKq7UrmviQsHA=";
  };

  webui = buildNpmPackage {
    inherit src version;
    pname = "zinc-ui";

    sourceRoot = "source/web";

    npmDepsHash = "sha256-clRijS+hxWc1LwlAKjEEk/6XPBYC6CcLq5g/ry4a04g=";

    CYPRESS_INSTALL_BINARY = 0; # cypress tries to download binaries otherwise

    installPhase = ''
      mkdir -p $out/share
      mv dist $out/share/zinc-ui
    '';
  };
in
buildGoModule rec {
  pname = "zinc";
  inherit src version;

  preBuild = ''
    cp -r ${webui}/share/zinc-ui web/dist
  '';

  vendorSha256 = "sha256-akjb0cxHbITKS26c+7lVSHWO/KRoQVVKzAOra+tdAD8=";
  subPackages = [ "cmd/zinc" ];

  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/zinclabs/zinc/pkg/meta.Version=${version}"
  ];

  meta = with lib; {
    description = "A lightweight alternative to elasticsearch that requires minimal resources, written in Go";
    homepage = "https://github.com/zinclabs/zinc";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}

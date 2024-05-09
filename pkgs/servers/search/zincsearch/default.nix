{ lib
, buildGoModule
, fetchFromGitHub
, buildNpmPackage
}:

let
  version = "0.4.10";
  src = fetchFromGitHub {
    owner = "zinclabs";
    repo = "zincsearch";
    rev = "v${version}";
    hash = "sha256-lScwnmu4hM78Va7Yi5HA0E5f2WQXrZaeqjRYJYxnQ5E=";
  };

  webui = buildNpmPackage {
    inherit src version;
    pname = "zinc-ui";

    sourceRoot = "${src.name}/web";

    npmDepsHash = "sha256-2AjUaEOn2Tj+X4f42SvNq1kX07WxkB1sl5KtGdCjbdw=";

    env = {
      CYPRESS_INSTALL_BINARY = 0; # cypress tries to download binaries otherwise
    };

    installPhase = ''
      mkdir -p $out/share
      mv dist $out/share/zinc-ui
    '';
  };
in

buildGoModule rec {
  pname = "zincsearch";
  inherit src version;

  preBuild = ''
    cp -r ${webui}/share/zinc-ui web/dist
  '';

  vendorHash = "sha256-SZG5/ISGblpcwwR/HOKxFl9SthXpE+IYS0S+4HYtHos=";
  subPackages = [ "cmd/zincsearch" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/zinclabs/zincsearch/pkg/meta.Version=${version}"
  ];

  meta = with lib; {
    description = "A lightweight alternative to elasticsearch that requires minimal resources, written in Go";
    mainProgram = "zincsearch";
    homepage = "https://zincsearch-docs.zinc.dev/";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}

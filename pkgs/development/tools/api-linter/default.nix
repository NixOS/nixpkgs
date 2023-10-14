{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "api-linter";
  version = "1.58.1";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "api-linter";
    rev = "v${version}";
    hash = "sha256-4k8Ms+ANROe9wBo5XLckyRZbTVegf3p5ab7HCdTwS+A=";
  };

  vendorHash = "sha256-DYGBrzbslrtoUWaUag7tiEpi5Tn4ZbyX62NrQpK1ySA=";

  subPackages = [ "cmd/api-linter" ];

  ldflags = [
    "-s"
    "-w"
  ];

  # reference: https://github.com/googleapis/api-linter/blob/v1.58.1/.github/workflows/release.yaml#L76
  preBuild = ''
    cat > cmd/api-linter/version.go <<EOF
    package main
    const version = "${version}"
    EOF
  '';

  meta = with lib; {
    description = "Linter for APIs defined in protocol buffers";
    homepage = "https://github.com/googleapis/api-linter/";
    changelog = "https://github.com/googleapis/api-linter/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ xrelkd ];
  };
}

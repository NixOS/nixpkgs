{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "gh-dash";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "dlvhdr";
    repo = "gh-dash";
    rev = "v${version}";
    sha256 = "sha256-y7PJ8BDTiip6cjKQ3CVIcf3LwlGsEj3DHn3EOtCGa4A=";
  };

  vendorSha256 = "sha256-Hk/sBUI2XYB+ZHfuGUR3muEzUtVsGR28EkRD1jKg0Ss=";

  ldflags = [ "-s" "-w" ];

  meta = {
    description = "gh extension to display a dashboard with pull requests and issues";
    homepage = "https://github.com/dlvhdr/gh-dash";
    changelog = "https://github.com/dlvhdr/gh-dash/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ amesgen ];
  };
}

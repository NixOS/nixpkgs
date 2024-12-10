{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "xurls";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = "xurls";
    rev = "v${version}";
    sha256 = "sha256-9hPXZ/t15+LG9fji1gyeWhUrYOr6eGyKYg3a1SmHJpQ=";
  };

  vendorHash = "sha256-eVK7qU+NWsarBsEpg6aGow/urmhIpU3Z9RwoTvSymXo=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Extract urls from text";
    homepage = "https://github.com/mvdan/xurls";
    maintainers = with maintainers; [ koral ];
    license = licenses.bsd3;
  };
}

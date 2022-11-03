{ lib, buildGoModule, fetchFromGitHub, updateGolangSysHook }:

buildGoModule rec {
  pname = "kail";
  version = "0.15.0";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  src = fetchFromGitHub {
    owner = "boz";
    repo = "kail";
    rev = "v${version}";
    sha256 = "0b4abzk8lc5qa04ywkl8b5hb9jmxhyi2dpgbl27gmw81525wjnj7";
  };

  nativeBuildInputs = [ updateGolangSysHook ];

  vendorSha256 = "sha256-YB1J8Kplo2jcDgCp3eTDAQOaIz8rwJdXWIBReGdY/Yc=";

  meta = with lib; {
    description = "Kubernetes log viewer";
    homepage = "https://github.com/boz/kail";
    license = licenses.mit;
    maintainers = with maintainers; [ offline vdemeester ];
  };
}

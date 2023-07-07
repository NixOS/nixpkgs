{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "containerlab";
  version = "0.42.0";

  src = fetchFromGitHub {
    owner = "srl-labs";
    repo = "containerlab";
    rev = "v${version}";
    hash = "sha256-Vs3+5lnHy1QOisyq8heHlkE+Ezd6jDTFiTZUPxNQDnA=";
  };

  vendorHash = "sha256-QaL4dlGw0az/hnYK20UOgh+AZ4wjhaopesJeN4zmeFE=";

  ldflags = [
    "-s"
    "-w"
    "-X" "github.com/srl-labs/containerlab/cmd.version=${version}"
    "-X" "github.com/srl-labs/containerlab/cmd.commit=${src.rev}"
    "-X" "github.com/srl-labs/containerlab/cmd.date=1970-01-01T00:00:00Z"
  ];

  meta = with lib; {
    description = "Container-based networking lab";
    homepage = "https://containerlab.dev/";
    changelog = "https://github.com/srl-labs/containerlab/releases/tag/${src.rev}";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ janik ];
  };
}

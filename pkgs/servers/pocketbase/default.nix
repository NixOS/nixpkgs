{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "pocketbase";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "pocketbase";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-CKlmHOaBQZbaRc0kYacaVFhpG11CTA9Q1JPZCwDZjn0=";
  };

  vendorHash = "sha256-rNqZ49XbkS2c8XeSQg8igc5zM+NqWMb6dGsh4dakamI=";

  # This is the released subpackage from upstream repo
  subPackages = [ "examples/base" ];

  CGO_ENABLED = 0;

  # Upstream build instructions
  ldflags = [
    "-s"
    "-w"
    "-X github.com/pocketbase/pocketbase.Version=${version}"
  ];

  postInstall = ''
    mv $out/bin/base $out/bin/pocketbase
  '';

  meta = with lib; {
    description = "Open Source realtime backend in 1 file";
    homepage = "https://github.com/pocketbase/pocketbase";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}

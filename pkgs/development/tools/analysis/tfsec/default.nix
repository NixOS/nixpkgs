{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tfsec";
  version = "1.28.5";

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = "tfsec";
    rev = "refs/tags/v${version}";
    hash = "sha256-zMOAXuMOuWzV5uqzNvw+2DiEA9o/80v7DW5KDhoT/fg=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/aquasecurity/tfsec/version.Version=v${version}"
    ## not sure if this is needed (https://github.com/aquasecurity/tfsec/blob/master/.goreleaser.yml#L6)
    # "-extldflags '-fno-PIC -static'"
  ];

  vendorHash = "sha256-nBjlsDFjkqwFBwNnGk8WC+XM5xBuopyrloPlQyOReuY=";

  subPackages = [
    "cmd/tfsec"
    "cmd/tfsec-docs"
    "cmd/tfsec-checkgen"
  ];

  meta = with lib; {
    description = "Static analysis powered security scanner for terraform code";
    homepage = "https://github.com/aquasecurity/tfsec";
    changelog = "https://github.com/aquasecurity/tfsec/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab marsam peterromfeldhk ];
  };
}

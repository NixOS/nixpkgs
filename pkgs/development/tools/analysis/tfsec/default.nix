{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tfsec";
  version = "1.28.2";

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-N1BL0DHppHyfxHQT98y3rtvyCArq/bcbDIiB0NxCsJA=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X github.com/aquasecurity/tfsec/version.Version=v${version}"
    ## not sure if this is needed (https://github.com/aquasecurity/tfsec/blob/master/.goreleaser.yml#L6)
    # "-extldflags '-fno-PIC -static'"
  ];

  vendorHash = "sha256-7OTMJhW1Q1z/TOFa4oRCEIPF0cN8gZLdaQglqszXHdw=";

  subPackages = [
    "cmd/tfsec"
    "cmd/tfsec-docs"
    "cmd/tfsec-checkgen"
  ];

  meta = with lib; {
    description = "Static analysis powered security scanner for terraform code";
    homepage = "https://github.com/aquasecurity/tfsec";
    license = licenses.mit;
    maintainers = with maintainers; [ fab marsam peterromfeldhk ];
  };
}

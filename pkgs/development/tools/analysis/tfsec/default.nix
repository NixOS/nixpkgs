{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tfsec";
  version = "1.28.4";

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = "tfsec";
    rev = "refs/tags/v${version}";
    hash = "sha256-WMmRCjKBtPT45it6iUQh5D7TBc8glt+dppksBvDhTN4=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/aquasecurity/tfsec/version.Version=v${version}"
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
    changelog = "https://github.com/aquasecurity/tfsec/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab marsam peterromfeldhk ];
  };
}

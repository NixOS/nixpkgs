{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tfsec";
  version = "1.28.0";

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-j+Q92DUqb06w1aDBX4T+4btN5YrizbIWln8fqRrk1hw=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X github.com/aquasecurity/tfsec/version.Version=${version}"
    ## not sure if this is needed (https://github.com/aquasecurity/tfsec/blob/master/.goreleaser.yml#L6)
    # "-extldflags '-fno-PIC -static'"
  ];

  vendorSha256 = "sha256-Avwr7A2X68sZgXUGl+Pgci+QtG9tsZMsyYkVeC4p2oQ=";

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

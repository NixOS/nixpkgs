{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tfsec";
  version = "1.27.4";

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-0sW5I/oCPIXxc0F76P0iQwHkKbiNKPdyt0+luyHVAE0=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X github.com/aquasecurity/tfsec/version.Version=${version}"
    ## not sure if this is needed (https://github.com/aquasecurity/tfsec/blob/master/.goreleaser.yml#L6)
    # "-extldflags '-fno-PIC -static'"
  ];

  vendorSha256 = "sha256-DDYM0UGw/1hLtsSjZL4ALnd1FHxcGtfX27m8vlZBQrA=";

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

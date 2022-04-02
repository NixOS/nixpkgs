{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tfsec";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-4YojzVwvPc+9Mn+xyRMxGEKv68eekXpH0RzSsrd8voY=";
  };

  ldflags = [
    "-s" "-w"
    "-X github.com/aquasecurity/tfsec/version.Version=${version}"
    ## not sure if this is needed (https://github.com/aquasecurity/tfsec/blob/master/.goreleaser.yml#L6)
    # "-extldflags '-fno-PIC -static'"
  ];

  vendorSha256 = "sha256-/r1KMX5YqJ3bVXNYJWv10cHkBQMuS90KMGXWUB6Idw8=";

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

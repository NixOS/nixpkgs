{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tfsec";
  version = "1.21.2";

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-oKHGowW/LetNGtMA/sTWhmc98Tt6X475CbpqI88g4Jc=";
  };

  ldflags = [
    "-s" "-w"
    "-X github.com/aquasecurity/tfsec/version.Version=${version}"
    ## not sure if this is needed (https://github.com/aquasecurity/tfsec/blob/master/.goreleaser.yml#L6)
    # "-extldflags '-fno-PIC -static'"
  ];

  vendorSha256 = "sha256-l39wXMgJLWIf0TcM6VQpcV4ckHqW/SjMy07e9w7dbgs=";

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

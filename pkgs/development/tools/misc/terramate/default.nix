{ lib
, buildGoModule
, fetchFromGitHub
, git
}:

buildGoModule rec {
  pname = "terramate";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "terramate-io";
    repo = "terramate";
    rev = "v${version}";
    hash = "sha256-aOKUC1FtDDhdUbPUSLW6GrSwh6r29Y2ObC6y487W4Zc=";
  };

  vendorHash = "sha256-gl5xsaSkGXlh+MfieVBPHGAbYZVF3GBbIkmvVhlJvqw=";

  # required for version info
  nativeBuildInputs = [ git ];

  ldflags = [ "-extldflags" "-static" ];

  meta = with lib; {
    description = "Adds code generation, stacks, orchestration, change detection, data sharing and more to Terraform";
    homepage = "https://github.com/terramate-io/terramate";
    license = licenses.mpl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}

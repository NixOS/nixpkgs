{ lib
, buildGoModule
, fetchFromGitHub
, git
}:

buildGoModule rec {
  pname = "terramate";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "terramate-io";
    repo = "terramate";
    rev = "v${version}";
    hash = "sha256-64tzzruhypIgDbsIOkAenyAYaRnCJiOIiuib3YPI0XI=";
  };

  vendorHash = "sha256-/PKibIGNeam6fP2eLUYd2kxlTO4KcboIbUQ2lKe2qYY=";

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

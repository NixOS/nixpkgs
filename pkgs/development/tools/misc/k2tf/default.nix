{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "k2tf";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "sl1pm4t";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-75L8fcmZbG7PbZrF4cScRQjqbuu5eTnLIaDGzgF57/0=";
  };

  vendorSha256 = "sha256-YsSOw3G5ufxBn8Wu5J8md2Aaqhl0VJa7uB6ZzSPWo/A=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" "-X main.commit=v${version}" ];

  meta = with lib; {
    description = "Kubernetes YAML to Terraform HCL converter";
    homepage = "https://github.com/sl1pm4t/k2tf";
    license = licenses.mpl20;
    maintainers = [ maintainers.flokli ];
  };
}

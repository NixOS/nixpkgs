{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "k2tf";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "sl1pm4t";
    repo = pname;
    rev = "v${version}";
    sha256 = "0i1bhn0sccvnqbd4kv2xgng5r68adhcc61im2mn8hxmds5nf6in2";
  };

  vendorSha256 = "1c2mwhrj0xapc661z1nb6am4qq3rd1pvbvjaxikjyx95n0gs8gjk";

  ldflags = [ "-s" "-w" "-X main.version=${version}" "-X main.commit=v${version}" ];

  meta = with lib; {
    description = "Kubernetes YAML to Terraform HCL converter";
    homepage = "https://github.com/sl1pm4t/k2tf";
    license = licenses.mpl20;
    maintainers = [ maintainers.flokli ];
  };
}

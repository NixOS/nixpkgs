{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "viddy";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "sachaos";
    repo = pname;
    rev = "v${version}";
    sha256 = "18ms4kfv332863vd8b7mmrz39y4b8gvhi6lx9x5385jfzd19w5wx";
  };

  vendorSha256 = "0789wq4d9cynyadvlwahs4586gc3p78gdpv5wf733lpv1h5rjbv3";

  ldflags = [
    "-s"
    "-w"
    "-X"
    "main.version=${version}"
  ];

  meta = with lib; {
    description = "A modern watch command";
    homepage = "https://github.com/sachaos/viddy";
    license = licenses.mit;
    maintainers = with maintainers; [ j-hui ];
  };
}

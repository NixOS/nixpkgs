{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "hcledit";
  version = "0.2.10";

  src = fetchFromGitHub {
    owner = "minamijoyo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-rXmbRbM6U1JtV3t8C0LlLAdYpxd4UjxrbrPVHdqiCJ8=";
  };

  vendorHash = "sha256-9ND/vDPDn3rn213Jn1UPMmYAkMI86gYx9QLcV/oFGh4=";

  meta = with lib; {
    description = "A command line editor for HCL";
    homepage = "https://github.com/minamijoyo/hcledit";
    license = licenses.mit;
    maintainers = with maintainers; [ aleksana ];
  };
}

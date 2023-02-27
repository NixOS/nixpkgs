{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "yatas";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "padok-team";
    repo = "YATAS";
    rev = "refs/tags/v${version}";
    hash = "sha256-BjcqEO+rDEjPttGgTH07XyQKLcs/O+FarKTWjqXWQOo=";
  };

  vendorHash = "sha256-QOFt9h4Hdt+Mx82yw4mjAoyUXHeprvjRoLYLBnihwJo=";

  meta = with lib; {
    description = "Tool to audit AWS infrastructure for misconfiguration or potential security issues";
    homepage = "https://github.com/padok-team/YATAS";
    changelog = "https://github.com/padok-team/YATAS/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}

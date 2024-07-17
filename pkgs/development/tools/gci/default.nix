{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "gci";
  version = "0.13.4";

  src = fetchFromGitHub {
    owner = "daixiang0";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-nJyRgvMVmNmmxigsdDcKzUuTQg5lXa8JnmwVyQwyWxA=";
  };

  vendorHash = "sha256-/8fggERlHySyimrGOHkDERbCPZJWqojycaifNPF6MjE=";

  meta = with lib; {
    description = "Controls golang package import order and makes it always deterministic";
    homepage = "https://github.com/daixiang0/gci";
    license = licenses.bsd3;
    maintainers = with maintainers; [ krostar ];
  };
}

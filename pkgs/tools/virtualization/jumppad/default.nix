{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "jumppad";
  version = "0.5.38";

  src = fetchFromGitHub {
    owner = "jumppad-labs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-s779QQ1fzVKFIMoj7X3MLLo1Z3NBSGPoKoDi3xM0fr8=";
  };
  vendorHash = "sha256-37j7taSmWhs9NQbv41aljR07HCTRrLd3ddiktV/XKBs=";

  ldflags = [
    "-s" "-w" "-X main.version=${version}"
  ];

  # Tests require a large variety of tools and resources to run including
  # Kubernetes, Docker, and GCC.
  doCheck = false;

  meta = with lib; {
    description = "A tool for building modern cloud native development environments";
    homepage = "https://jumppad.dev";
    license = licenses.mpl20;
    maintainers = with maintainers; [ cpcloud ];
  };
}

{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, testers
, d2
}:

buildGoModule rec {
  pname = "d2";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "terrastruct";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-1AFioXDIh+qQYhhIaQky2SkGd+amnYdOeoNDU+1+poI=";
  };

  vendorHash = "sha256-PtKKGHzxshahecbfvvo1nGCseap4o8r8raBpFDUSbx4=";

  ldflags = [
    "-s"
    "-w"
    "-X oss.terrastruct.com/d2/lib/version.Version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage ci/release/template/man/d2.1
  '';

  subPackages = [ "." ];

  passthru.tests.version = testers.testVersion { package = d2; };

  meta = with lib; {
    description = "A modern diagram scripting language that turns text to diagrams";
    homepage = "https://d2lang.com";
    license = licenses.mpl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}

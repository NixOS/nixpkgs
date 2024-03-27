{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "govc";
  version = "0.36.2";

  subPackages = [ "govc" ];

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "vmware";
    repo = "govmomi";
    sha256 = "sha256-1Ap15DE+Fe76mDxrfeiVTYhur5GjZj0FzjvKDDWbhsg=";
  };

  vendorHash = "sha256-1EAQMYaTEtfAiu7+UTkC7QZwSWC1Ihwj9leTd90T0ZU=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/vmware/govmomi/govc/flags.BuildVersion=${version}"
  ];

  meta = {
    description = "A vSphere CLI built on top of govmomi";
    homepage = "https://github.com/vmware/govmomi/tree/master/govc";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nicknovitski ];
    mainProgram = "govc";
  };
}

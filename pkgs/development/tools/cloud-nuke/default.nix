{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cloud-nuke";
  version = "0.29.7";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-JIMEmXZVPXDR8t+ECaV5OqThHiW2CUn2BrIvM+uxSMI=";
  };

  vendorHash = "sha256-i+AzDEydK+mUvOb6LivuyaCqHaqIdPkE46nxvf7mLTw=";

  ldflags = [ "-s" "-w" "-X main.VERSION=${version}" ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/gruntwork-io/cloud-nuke";
    description = "A tool for cleaning up your cloud accounts by nuking (deleting) all resources within it";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}

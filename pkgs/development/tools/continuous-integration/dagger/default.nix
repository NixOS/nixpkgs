{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dagger";
  version = "0.2.34";

  src = fetchFromGitHub {
    owner = "dagger";
    repo = "dagger";
    rev = "v${version}";
    sha256 = "sha256-gUdvndL8v+7lX/GuMxHlHxp3j8YTQWEh3c+WX+fDOQU=";
  };

  vendorSha256 = "sha256-yNb5OvsnNAk+K0gepKVuqivS+eeLMOVCqxF/rj+Rpps=";

  subPackages = [
    "cmd/dagger"
  ];

  ldflags = [ "-s" "-w" "-X go.dagger.io/dagger/version.Version=${version}" ];

  meta = with lib; {
    description = "A portable devkit for CICD pipelines";
    homepage = "https://dagger.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ jfroche sagikazarmark ];
  };
}

{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "skaffold";
  version = "1.3.1";
  # rev is the 1.3.1 commit, mainly for skaffold version command output
  rev = "6ba887a42438d1da578a005cf550e618fee6dfb8";

  goPackagePath = "github.com/GoogleContainerTools/skaffold";
  subPackages = ["cmd/skaffold"];

  buildFlagsArray = let t = "${goPackagePath}/pkg/skaffold"; in  ''
    -ldflags=
      -X ${t}/version.version=v${version}
      -X ${t}/version.gitCommit=${rev}
      -X ${t}/version.buildDate=unknown
  '';

  src = fetchFromGitHub {
    owner = "GoogleContainerTools";
    repo = "skaffold";
    rev = "v${version}";
    sha256 = "1ph7qyk5khdinxbhgqhhja8fz8b6q8yz5rj5xh0nwaff4bmlfd99";
  };

  meta = {
    description = "Easy and Repeatable Kubernetes Development";
    homepage = https://github.com/GoogleContainerTools/skaffold;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ vdemeester ];
  };
}

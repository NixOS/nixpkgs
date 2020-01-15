{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "skaffold";
  version = "0.36.0";
  # rev is the 0.36.0 commit, mainly for skaffold version command output
  rev = "1c054d4ffc7e14b4d81efcbea8b2022403ee4b89";

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
    sha256 = "1d7z36r33lmxm5cv1kby6g9zbsr88prgsp32x4jcs9l1ifwblhng";
  };

  meta = {
    description = "Easy and Repeatable Kubernetes Development";
    homepage = https://github.com/GoogleContainerTools/skaffold;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ vdemeester ];
  };
}

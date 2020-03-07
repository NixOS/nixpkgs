{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "pack";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "buildpacks";
    repo = pname;
    rev = "v${version}";
    sha256 = "0glfxrw3x35m4nmhr9xwlc14y5g9zni85rcrcn3dvkvgh4m6ipaj";
  };

  goPackagePath = "github.com/buildpacks/pack";

  subPackages = [ "cmd/pack" ];

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/buildpacks/pack/cmd.Version=${version}" ];

  meta = with lib; {
    homepage = "https://buildpacks.io/";
    changelog = "https://github.com/buildpacks/pack/releases/tag/v${version}";
    description = "Local CLI for building apps using Cloud Native Buildpacks";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}

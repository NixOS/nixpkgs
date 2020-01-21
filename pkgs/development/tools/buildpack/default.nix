{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "pack";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "buildpacks";
    repo = pname;
    rev = "v${version}";
    sha256 = "00v4kb9cv6nn7vrybjkv0kgcvfm5dsg0168dv253mrp9xmv8kd9l";
  };

  goPackagePath = "github.com/buildpacks/pack";

  subPackages = [ "cmd/pack" ];

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/buildpacks/pack/cmd.Version=${version}" ];

  meta = with lib; {
    homepage = "https://buildpacks.io/";
    description = "Local CLI for building apps using Cloud Native Buildpacks";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}

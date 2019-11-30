{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "pack";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "buildpack";
    repo = pname;
    rev = "v${version}";
    sha256 = "0yh62h7lz2i07gixccmfyxk607djp1nrs57rzk7nkxnjcj4jj5sr";
  };

  goPackagePath = "github.com/buildpack/pack";

  subPackages = [ "cmd/pack" ];

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/buildpack/pack/cmd.Version=${version}" ];

  meta = with lib; {
    homepage = "https://buildpacks.io/";
    description = "Local CLI for building apps using Cloud Native Buildpacks";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}

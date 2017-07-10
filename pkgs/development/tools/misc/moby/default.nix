{ lib, buildGoPackage, go, fetchFromGitHub }:

buildGoPackage rec {
  name = "moby-${version}";
  version = "2017-07-06";
  rev = "d87a3f9990ed24ebbb51695879cd640cb07a4b40";

  goPackagePath = "github.com/moby/tool";

  src = fetchFromGitHub {
    owner = "moby";
    repo = "tool";
    inherit rev;
    sha256 = "0xhasm69g5gwihcm8g7rff9nkx7iffvd642bknky6j3w133gs5lp";
  };

  preBuild = ''
    buildFlagsArray+=("-ldflags" "-X main.GitCommit=${builtins.substring 0 7 rev} -X main.Version=0.0.0")
  '';

  meta = {
    description = "Assembly tool for the Moby project, an open framework to assemble specialized container systems without reinventing the wheel";
    license = lib.licenses.asl20;
    homepage = https://mobyproject.org;
    platforms = lib.platforms.unix;
  };
}

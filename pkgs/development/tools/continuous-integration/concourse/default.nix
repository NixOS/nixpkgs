{
  buildGoPackage,
  callPackage,
  fetchFromGitHub,
  go-packr,
  stdenv,
}:

let

  version = "5.0.2-pre";

  src = fetchFromGitHub {
    repo = "concourse";
    owner = "concourse";
    rev = "6c13d21d0efc407a12eb03196b1c3533e34e494d"; #"v${version}";
    sha256 = "1rd2j7lffwgcbg0yi4vjb3z5xrfs9g36db4i719l9d973qkwfxx1";
  };

  main-asset = callPackage ./assets/main {
    inherit src;
  };

  resources = import ./assets/resources { inherit callPackage fly; };

  mkResourcesDir = callPackage ./assets/resources/make-resource-dir.nix {};

  resourceDir = mkResourcesDir resources;

  buildConcourse = { name, packages, platforms, passthru ? {}, preBuild ? "" }:
    buildGoPackage rec {
      inherit name;
      goPackagePath = "github.com/concourse/concourse";
      subPackages = packages;
      goDeps = ./deps.nix;
      nativeBuildInputs = [ go-packr ];
      inherit src passthru preBuild;

      buildFlagsArray = ''
        -ldflags=
        -X github.com/concourse/concourse.Version=${version}
      '';

      meta = {
        inherit platforms;
        license = stdenv.lib.licenses.asl20;
        maintainers = with stdenv.lib.maintainers; [ edude03 dxf ];
      };
    };

  fly = buildConcourse {
    name = "fly-unstable";
    packages = [ "fly" ];
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };
in
{
  concourse = buildConcourse {
    name = "concourse-unstable";
    passthru = {
      inherit resources main-asset mkResourcesDir resourceDir;
    };
    packages = [ "cmd/concourse" ];
    platforms = stdenv.lib.platforms.linux;
    preBuild =''
      cp -R ${main-asset}/. go/src/github.com/concourse/concourse/web/
      packr -i go/src/github.com/concourse
    '';
  };

  inherit fly;
}

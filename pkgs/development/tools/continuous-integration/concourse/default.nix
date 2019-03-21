{
  buildGoPackage,
  callPackage,
  fetchFromGitHub,
  go-packr,
  stdenv,
}:

let

  version = "5.0.0";

  src = fetchFromGitHub {
    repo = "concourse";
    owner = "concourse";
    rev = "v${version}";
    sha256 = "0srnfawisvpisypiklhjbnfm8ppnx9g221vg23wi7vrpsk7bzin7";
  };

  main-asset = callPackage ./assets/main {
    inherit src;
  };

  resources = import ./assets/resources { inherit callPackage fly; };

  # TODO: Set this
  worker_vesion = "";

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

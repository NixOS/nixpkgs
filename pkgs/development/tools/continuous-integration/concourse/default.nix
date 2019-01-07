{
  buildGoPackage,
  callPackage,
  fetchFromGitHub,
  go-packr,
  stdenv,
}:

let

  version = "c862322702eea2fd561b1a04de18ab1c1ef4810b";

  src = fetchFromGitHub {
    repo = "concourse";
    owner = "concourse";
    rev = "${version}";
    sha256 = "1l8grpr6w5badz9khwdcrhf07a8g8p9gax6djkbr0sq50xn68lfc";
  };

  main-asset = callPackage ./assets/main {
    inherit src;
  };

  resources = import ./assets/resources { inherit callPackage; };

  # TODO: Set this
  worker_vesion = "";

  mkResourcesDir = callPackage ./assets/resources/make-resource-dir.nix {};

  resourceDir = mkResourcesDir resources;
in
buildGoPackage rec {
  passthru = {
    inherit resources main-asset mkResourcesDir resourceDir;
  };

  name = "concourse-unstable";
  goPackagePath = "github.com/concourse/concourse";
  subPackages = [ "bin/cmd/concourse" "fly"];
  goDeps = ./deps.nix;
  nativeBuildInputs = [ go-packr ];
  inherit src;

  preBuild = ''
    cp -R ${main-asset}/. go/src/github.com/concourse/concourse/web/
    packr -i go/src/github.com/concourse
  '';

  # TODO: Get Worker version
  #-X github.com/concourse/atc/atccmd.WorkerVersion=${worker_version}
  #-X main.WorkerVersion=${worker_version}
  buildFlagsArray = ''
    -ldflags=
    -X github.com/concourse/concourse/fly/version.Version=${version}
    -X main.Version=${version}
    -X github.com/concourse/concourse/atc/atccmd.Version=${version}
  '';

  meta = {
    platforms = stdenv.lib.platforms.linux;
  };
}

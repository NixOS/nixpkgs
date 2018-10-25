{
  buildGoPackage,
  callPackage,
  fetchFromGitHub,
  go-packr,
  stdenv,
}:

let

  version = "d41bd4369bedff638cb02ad16ab042c3c9165b3a";

  src = fetchFromGitHub {
    repo = "concourse";
    owner = "concourse";
    rev = "${version}";
    sha256 = "1wmx675xrav3mwcmk52fav69wmni8cn1xf9xklk18lpr8vz7khcw";
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

{ lib
, buildGoModule
, fetchFromGitHub
, git
, stdenv
, testers
, manifest-tool
}:

buildGoModule rec {
  pname = "manifest-tool";
  version = "2.1.6";
  modRoot = "v2";

  src = fetchFromGitHub {
    owner = "estesp";
    repo = "manifest-tool";
    rev = "v${version}";
    hash = "sha256-/u60hi/KnPVWlNh6nxjXpH0ct5PLVE44deGxhzbayD0=";
    leaveDotGit = true;
    postFetch = ''
      git -C $out rev-parse HEAD > $out/.git-revision
      rm -rf $out/.git
    '';
  };

  vendorHash = null;

  nativeBuildInputs = [ git ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ] ++ lib.optionals stdenv.hostPlatform.isStatic [
    "-linkmode=external"
    "-extldflags"
    "-static"
  ];

  preConfigure = ''
    export ldflags+=" -X main.gitCommit=$(cat .git-revision)"
  '';

  tags = lib.optionals stdenv.hostPlatform.isStatic [
    "cgo"
    "netgo"
    "osusergo"
    "static_build"
  ];

  passthru.tests.version = testers.testVersion {
    package = manifest-tool;
  };

  meta = with lib; {
    description = "Command line tool to create and query container image manifest list/indexes";
    mainProgram = "manifest-tool";
    homepage = "https://github.com/estesp/manifest-tool";
    license = licenses.asl20;
    maintainers = with maintainers; [ tricktron ];
  };
}

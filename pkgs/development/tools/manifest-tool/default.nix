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
  version = "2.1.5";
  modRoot = "v2";

  src = fetchFromGitHub {
    owner = "estesp";
    repo = "manifest-tool";
    rev = "v${version}";
    hash = "sha256-TCR8A35oETAZszrZFtNZulzCsh9UwGueTyHyYe+JQeI=";
    leaveDotGit = true;
    postFetch = ''
      git -C $out rev-parse HEAD > $out/.git-revision
      rm -rf $out/.git
    '';
  };

  vendorHash = null;

  nativeBuildInputs = [ git ];

  preConfigure = ''
    ldflags="-X main.gitCommit=$(cat .git-revision) -X main.version=${version}"
  '';

  CGO_ENABLED = if stdenv.hostPlatform.isStatic then "0" else "1";
  GO_EXTLINK_ENABLED = if stdenv.hostPlatform.isStatic then "0" else "1";
  ldflags = lib.optionals stdenv.hostPlatform.isStatic [ "-w" "-extldflags" "-static" ];
  tags = lib.optionals stdenv.hostPlatform.isStatic [ "netgo" ];

  passthru.tests.version = testers.testVersion {
    package = manifest-tool;
  };

  meta = with lib; {
    description = "Command line tool to create and query container image manifest list/indexes";
    homepage = "https://github.com/estesp/manifest-tool";
    license = licenses.asl20;
    maintainers = with maintainers; [ tricktron ];
  };
}

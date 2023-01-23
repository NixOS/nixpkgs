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
  version = "2.0.6";
  gitCommit = "2ed9312726765567a84f2acc44a0c8a6e50f4b7a";
  modRoot = "v2";

  src = fetchFromGitHub {
    owner = "estesp";
    repo = "manifest-tool";
    rev = "v${version}";
    sha256 = "sha256-oopk++IdNF6msxOszT0fKxQABgWKbaQZ2aNH9chqWU0=";
    leaveDotGit = true;
    postFetch = ''
      git -C $out rev-parse HEAD > $out/.git-revision
      rm -rf $out/.git
    '';
  };

  vendorHash = null;

  nativeBuildInputs = [ git ];

  preConfigure = ''
    ldflags="-X main.gitCommit=$(cat .git-revision)"
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

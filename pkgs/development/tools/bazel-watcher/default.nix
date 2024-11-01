{
  lib,
  fetchFromGitHub,
  buildGoModule,
  testers,
  bazel-watcher,
}:

buildGoModule rec {
  pname = "bazel-watcher";
  version = "0.25.3";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "bazel-watcher";
    rev = "v${version}";
    hash = "sha256-5cRj04e5VVG4NSe4LOLkZIrerT4laLEDeXCqTiJj6MM=";
  };

  vendorHash = "sha256-0I/bvuyosN55oNSMuom4C8rVjxneUaqV19l9OMiwWhU=";

  CGO_ENABLED = "0";
  ldflags = [
    "-s"
    "-X main.Version=${version}"
  ];

  subPackages = [ "cmd/ibazel" ];

  passthru = {
    tests.version = testers.testVersion { package = bazel-watcher; };
  };

  meta = with lib; {
    homepage = "https://github.com/bazelbuild/bazel-watcher";
    description = "Tools for building Bazel targets when source files change";
    license = licenses.asl20;
    maintainers = with maintainers; [ kalbasit ];
    mainProgram = "ibazel";
    platforms = platforms.all;
  };
}

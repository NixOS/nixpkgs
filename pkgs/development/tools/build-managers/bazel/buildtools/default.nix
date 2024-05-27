{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "bazel-buildtools";
  version = "7.1.2";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "buildtools";
    rev = "v${version}";
    hash = "sha256-Ax7UKkClYsoqxaR+tsQnTv6BFafl9SkY7MC4kYJNmwY=";
  };

  vendorHash = "sha256-DigTREfI6I48wxRpGp/bfH1NbUZ4E1B5UTQXpI0LY1A=";

  preBuild = ''
    rm -r warn/docs
  '';

  proxyVendor = true;

  doCheck = false;

  excludedPackages = [ "generatetables" ];

  ldflags = [ "-s" "-w" "-X main.buildVersion=${version}" "-X main.buildScmRevision=${src.rev}" ];

  meta = with lib; {
    description = "Tools for working with Google's bazel buildtool. Includes buildifier, buildozer, and unused_deps";
    homepage = "https://github.com/bazelbuild/buildtools";
    changelog = "https://github.com/bazelbuild/buildtools/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers;
      [ elasticdog uri-canva ]
      ++ lib.teams.bazel.members;
  };
}

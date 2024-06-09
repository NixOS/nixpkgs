{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "bazel-remote";
  version = "2.4.4";

  src = fetchFromGitHub {
    owner = "buchgr";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ncYE48DtH+mIM9ZR7IB38SzQFordhMGLp79poqDKWLE=";
  };

  vendorHash = "sha256-7rxrnxZwxqRRQf1sWk8ILi2IV/pYmxBuwHl9khfCrKE=";

  subPackages = [ "." ];

  doCheck = false;

  ldflags = [ "-s" "-w" "-X main.gitCommit=${version}" ];

  meta = with lib; {
    homepage = "https://github.com/buchgr/bazel-remote";
    description = "A remote HTTP/1.1 cache for Bazel";
    mainProgram = "bazel-remote";
    changelog = "https://github.com/buchgr/bazel-remote/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = lib.teams.bazel.members;
    platforms = platforms.darwin ++ platforms.linux;
  };
}

{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "bazel-remote";
  version = "2.4.3";

  src = fetchFromGitHub {
    owner = "buchgr";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-yvdsRc5KZAwzekktSu9tR9R2vvAMi+4JVkvy+ANFkQ8=";
  };

  vendorHash = "sha256-0rmqsUMwk5ytAZc94JzvZTuh0WAmQwBEWSE96yNALE0=";

  subPackages = [ "." ];

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.gitCommit=${version}"
  ];

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

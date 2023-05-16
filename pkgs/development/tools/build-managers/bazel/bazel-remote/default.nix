{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "bazel-remote";
<<<<<<< HEAD
  version = "2.4.3";
=======
  version = "2.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "buchgr";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-yvdsRc5KZAwzekktSu9tR9R2vvAMi+4JVkvy+ANFkQ8=";
  };

  vendorHash = "sha256-0rmqsUMwk5ytAZc94JzvZTuh0WAmQwBEWSE96yNALE0=";

  subPackages = [ "." ];

  doCheck = false;

  ldflags = [ "-s" "-w" "-X main.gitCommit=${version}" ];

  meta = with lib; {
    homepage = "https://github.com/buchgr/bazel-remote";
    description = "A remote HTTP/1.1 cache for Bazel";
    changelog = "https://github.com/buchgr/bazel-remote/releases/tag/v${version}";
=======
    sha256 = "sha256-aC1I+33jEmgjtidA5CQXpwePsavwlx97abpsc68RkBI=";
  };

  vendorHash = "sha256-4vNRtFqtzoDHjDQwPe1/sJNzcCU+b7XHgQ5YqEzNhjI=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/buchgr/bazel-remote";
    description = "A remote HTTP/1.1 cache for Bazel";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = lib.teams.bazel.members;
    platforms = platforms.darwin ++ platforms.linux;
  };
}

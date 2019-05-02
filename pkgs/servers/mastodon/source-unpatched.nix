let
  pkgs = import <nixpkgs> {};
in
  pkgs.fetchFromGitHub {
    owner = "tootsuite";
    repo = "mastodon";
    rev = "c4118ba71ba31e408c02d289e111326ccc6f6aa2";
    sha256 = "11vljzarhgs6hik6qhimlaimqm5ysljf9jm402r5fpy6axh6yksc";
  }
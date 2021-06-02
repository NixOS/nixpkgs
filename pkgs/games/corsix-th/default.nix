{ fetchFromGitHub, lib, newScope, audioSupport ? true, movieSupport ? true, freetypeSupport ? true, buildDocs ? false, enableUnitTests ? false }:

let
  baseName = "corsix-th";
  version = "0.64";
  githubSource = fetchFromGitHub {
    owner = "CorsixTH";
    repo = "CorsixTH";
    rev = "v${version}";
    sha256 = "0chh9cv2kdc39sr0x8hclcyzd8dz2y6grgagqzkvr7j570wa5cqh";
  };
in
lib.makeScope newScope (self: with self; {
  corsix-th = callPackage ./corsix-th.nix { inherit baseName version githubSource audioSupport movieSupport freetypeSupport buildDocs enableUnitTests; };
  # anim-view = callPackage ./anim-view.nix { inherit baseName version githubSource; };
  level-edit = callPackage ./level-edit.nix { inherit baseName version githubSource; };
})

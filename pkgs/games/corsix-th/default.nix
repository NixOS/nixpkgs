{ fetchFromGitHub, lib, newScope, audioSupport ? true, movieSupport ? true, freetypeSupport ? true, buildDocs ? false, enableUnitTests ? false }:

let
  baseName = "corsix-th";
  version = "0.65";
  githubSource = fetchFromGitHub {
    owner = "CorsixTH";
    repo = "CorsixTH";
    rev = "v${version}";
    sha256 = "0hp7da7b73dpn1h22rw3h8w6aaj9azn18qnp3ap3lrlqhj4fzcb3";
  };
in
lib.makeScope newScope (self: with self; {
  corsix-th = callPackage ./corsix-th.nix { inherit baseName version githubSource audioSupport movieSupport freetypeSupport buildDocs enableUnitTests; };
  anim-view = callPackage ./anim-view.nix { inherit baseName version githubSource; };
  level-edit = callPackage ./level-edit.nix { inherit baseName version githubSource; };
})

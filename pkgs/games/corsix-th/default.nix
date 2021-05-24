{ fetchFromGitHub, lib, newScope, audioSupport ? true, movieSupport ? true, freetypeSupport ? true, buildDocs ? false, enableUnitTests ? false, buildAnimView ? true, buildLevelEdit ? true }:

let
    baseName = "corsix-th";
    version = "0.64";
    githubSource = fetchFromGitHub {
        owner = "CorsixTH";
        repo = "CorsixTH";
        rev = "8741d41eb5de865c633e023bcb512b779c131c5e";
        sha256 = "0chh9cv2kdc39sr0x8hclcyzd8dz2y6grgagqzkvr7j570wa5cqh";
    };
in
lib.makeScope newScope (self: with self; {
    corsix-th = callPackage ./corsix-th.nix { inherit baseName; inherit version; inherit githubSource; inherit audioSupport; inherit movieSupport; inherit freetypeSupport; inherit buildDocs; inherit enableUnitTests; };
    # anim-view = if buildAnimView then callPackage ./anim-view.nix { inherit baseName; inherit version; inherit githubSource; } else null;
    level-edit = if buildLevelEdit then callPackage ./level-edit.nix { inherit baseName; inherit version; inherit githubSource; } else null;
})

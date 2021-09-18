{ callPackage, runtimeShell }:

(callPackage ./build.nix {
  version = "a4da4dfac44d1bbc6986c5c76fea45a60ebdd8e5";
  sha256  = "0gcjpw2q263hh8w2sjvq3f3k2d28qpkkv0jnl8hw1l7v604i8zxg";
}).overrideAttrs (old: {
  postPatch = old.postPatch or "" + ''
    echo 'echo ${runtimeShell}' > scripts/find_shell
  '';
})

with (import <nixpkgs> {});

mkShell {
  buildInputs = [ nix git cacert getopt nix-update ];
}

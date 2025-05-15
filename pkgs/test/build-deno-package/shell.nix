let
  pkgs = import <nixpkgs> { };
in
pkgs.mkShell {
  buildInputs = [ pkgs.deno ];
  DENO_DIR = "./.deno";

  shellHook = '''';
}

let
  pkgs = import ../../../default.nix { };
in
pkgs.mkShell {
  buildInputs = [ pkgs.deno ];
  DENO_DIR = "./.deno";

  shellHook = '''';
}

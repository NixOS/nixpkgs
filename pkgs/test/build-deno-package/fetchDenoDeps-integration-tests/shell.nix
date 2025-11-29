let
  inherit (import ../../../../default.nix { }) pkgs;

in
pkgs.mkShell {
  buildInputs = with pkgs; [
    deno
    diff-so-fancy
    static-web-server
  ];

  DENO_DIR = "./.deno";
  shellHook = '''';
}

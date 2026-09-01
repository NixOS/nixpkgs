let pkgs = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") {};
in pkgs.mkShell {
  buildInputs = [ pkgs.nodejs pkgs.kubo pkgs.electron ];
}

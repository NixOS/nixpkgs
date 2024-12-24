{ lib, runCommandLocal }:

# On darwin, there are some commands neither opensource nor able to build in nixpkgs.
# We have no choice but to use those system-shipped impure ones.

let
  commands = {
    ditto = "/usr/bin/ditto"; # ditto is not opensource
    sudo = "/usr/bin/sudo"; # sudo must be owned by uid 0 and have the setuid bit set
  };

  mkImpureDrv =
    name: path:
    runCommandLocal "${name}-impure-darwin"
      {
        __impureHostDeps = [ path ];

        meta = {
          platforms = lib.platforms.darwin;
        };
      }
      ''
        if ! [ -x ${path} ]; then
          echo Cannot find command ${path}
          exit 1
        fi

        mkdir -p $out/bin
        ln -s ${path} $out/bin

        manpage="/usr/share/man/man1/${name}.1"
        if [ -f $manpage ]; then
          mkdir -p $out/share/man/man1
          ln -s $manpage $out/share/man/man1
        fi
      '';
in
lib.mapAttrs mkImpureDrv commands

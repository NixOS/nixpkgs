{ pkgs }:
{
  inherit (pkgs.callPackage ./workspaces { })
    sub1
    sub2
    sub1Binary
    ;
  inherit (pkgs.callPackage ./binaries { })
    linux
    # mac
    ;
  inherit (pkgs.callPackage ./external { })
    readma-cli-linux
    fresh-init-cli-linux
    invidious-companion-cli-linux
    ;
}

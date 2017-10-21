{ stdenv, pkgs, fetchgit, nix, node_webkit, config, makeDesktopItem
, writeScript }:
let
  version = "0.2.1";
  src = fetchgit {
    url = "git://github.com/matejc/nixui.git";
    rev = "845a5f4a33f1d0c509c727c130d0792a5b450a38";
    sha256 = "1ay3i4lgzs3axbby06l4vvspxi0aa9pwiil84qj0dqq1jb6isara";
  };
  nixui = (import ./nixui.nix {
    inherit pkgs;
    inherit (stdenv) system;
  })."nixui-git://github.com/matejc/nixui.git#0.2.1";
  script = writeScript "nixui" ''
    #! ${stdenv.shell}
    export PATH="${nix}/bin:\$PATH"
    ${node_webkit}/bin/nw ${nixui}/lib/node_modules/nixui/
  '';
  desktop = makeDesktopItem {
    name = "nixui";
    exec = script;
    icon = "${nixui}/lib/node_modules/nixui/img/128.png";
    desktopName = "NixUI";
    genericName = "NixUI";
  };
in
stdenv.mkDerivation rec {
  name = "nixui-${version}";
  inherit version src;
  installPhase = ''
    mkdir -p $out/bin
    ln -s ${script} $out/bin/nixui

    mkdir -p $out/share/applications
    ln -s ${desktop}/share/applications/* $out/share/applications/
  '';
  meta = {
    description = "NodeWebkit user interface for Nix";
    homepage = https://github.com/matejc/nixui;
    license = stdenv.lib.licenses.asl20;
    maintainers = [ stdenv.lib.maintainers.matejc ];
    platforms = stdenv.lib.platforms.unix;
  };
}

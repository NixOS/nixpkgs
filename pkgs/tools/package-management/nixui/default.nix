{ stdenv, pkgs, fetchgit, nix, node_webkit, config, makeDesktopItem, writeScript
, profilePaths ? (config.nixui.profilePaths or ["/nix/var/nix/profiles"])
, dataDir ? (config.nixui.dataDir or "/tmp")
, configurations ? (config.nixui.configurations or ["/etc/nixos/configuration.nix"])
, NIX_PATH ? (config.nixui.NIX_PATH or "/nix/var/nix/profiles/per-user/root/channels/nixos:nixpkgs=/etc/nixos/nixpkgs:nixos-config=/etc/nixos/configuration.nix") }:
let
  version = "0.1.2";
  src = fetchgit {
    url = "git://github.com/matejc/nixui.git";
    rev = "refs/tags/${version}";
    sha256 = "0rq8q867j4fx5j8mkidbwgbzqj4w4xi45xr8ya79m6v3iqqblhhj";
  };
  nixui = (import ./node-default.nix { nixui = src; inherit pkgs; }).build;
  script = writeScript "nixui" ''
    #! ${stdenv.shell}
    export PATH="${nix}/bin:\$PATH"
    export NIXUI_CONFIG="${config}"
    ${node_webkit}/bin/nw ${nixui}/lib/node_modules/nixui/
  '';
  config = builtins.toFile "config.json" ''
  {
      "profilePaths": ${builtins.toJSON profilePaths},
      "dataDir": "${dataDir}",
      "configurations": ${builtins.toJSON configurations},
      "NIX_PATH": "${NIX_PATH}"
  }
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
    license = stdenv.lib.licenses.bsd2;
    maintainers = [ stdenv.lib.maintainers.matejc ];
    platforms = stdenv.lib.platforms.unix;
  };
}

{ lib, stdenv, pkgs, fetchFromGitHub, nix, node_webkit, makeDesktopItem
, writeScript }:
let
  nixui = (import ./nixui.nix {
    inherit pkgs;
    inherit (stdenv.hostPlatform) system;
  })."nixui-git+https://github.com/matejc/nixui.git#0.2.1";
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
  pname = "nixui";
  version = "0.2.1";
  src = fetchFromGitHub {
    owner = "matejc";
    repo = "nixui";
    rev = version;
    sha256 = "sha256-KisdzZIB4wYkJojGyG9SCsR+9d6EGuDX6mro/yiJw6s=";
  };
  installPhase = ''
    mkdir -p $out/bin
    ln -s ${script} $out/bin/nixui

    mkdir -p $out/share/applications
    ln -s ${desktop}/share/applications/* $out/share/applications/
  '';
  meta = {
    description = "NodeWebkit user interface for Nix";
    homepage = "https://github.com/matejc/nixui";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.matejc ];
    platforms = lib.platforms.unix;
  };
}

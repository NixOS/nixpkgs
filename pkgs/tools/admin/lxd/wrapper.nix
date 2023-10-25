{ lib
, lxd-unwrapped
, makeWrapper
, symlinkJoin
, writeShellScriptBin
, acl
, apparmor-parser
, apparmor-profiles
, attr
, bash
, btrfs-progs
, criu
, dnsmasq
, gnutar
, gzip
, iproute2
, iptables
, rsync
, squashfsTools
, xz
,
}:
let
  binPath = lib.makeBinPath [
    acl
    attr
    bash
    btrfs-progs
    criu
    dnsmasq
    gnutar
    gzip
    iproute2
    iptables
    rsync
    squashfsTools
    xz

    (writeShellScriptBin "apparmor_parser" ''
      exec '${apparmor-parser}/bin/apparmor_parser' -I '${apparmor-profiles}/etc/apparmor.d' "$@"
    '')
  ];
in
symlinkJoin {
  name = "lxd-${lxd-unwrapped.version}";

  paths = [ lxd-unwrapped ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/lxd --prefix PATH : ${lib.escapeShellArg binPath}
  '';

  passthru = {
    inherit (lxd-unwrapped) tests;
  };

  inherit (lxd-unwrapped) meta pname version;
}

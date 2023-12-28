{mkDerivation, lib, sysctl, bash, rcorder, bin, stat, id, protect, mount, ...}:
let
  rcDepsPath = lib.makeBinPath [
    sysctl
    bin
    bash
    rcorder
    stat
    id
    mount
    protect
  ];
in
mkDerivation rec {
  path = "libexec/rc";

  # no idea why but the normal derivation setup refuses to produce output even with the CONF* vars set.
  # TODO @rhelmot this is hardcoded for freebsd14
  executableFiles = builtins.map (x: "$BSDSRCDIR/${path}/${x}") [
    "netstart" "pccard_ether" "rc.resume" "rc.suspend"
  ];
  files = builtins.map (x: "$BSDSRCDIR/${path}/${x}") [
    "rc" "rc.bsdextended" "rc.firewall" "rc.initdiskless"
    "rc.shutdown" "rc.subr" "network.subr"
  ];

  patchPhase = ''
    sed -E -i -e "s|PATH=.*|PATH=${rcDepsPath}|g" $BSDSRCDIR/libexec/rc/rc
  '' + (let
    bins = ["/sbin/sysctl" "/usr/bin/protect" "/usr/bin/id" "/bin/ps" "/bin/cpuset" "/usr/bin/stat"
      "/bin/rm" "/bin/chmod" "/bin/cat" "/bin/sync" "/bin/sleep" "/bin/date"];
    scripts = ["rc" "rc.initdiskless" "rc.shutdown" "rc.subr" "rc.suspend" "rc.resume"];
  in lib.concatMapStringsSep "\n" (fname: ''sed -E -i -e "s|${fname}|${lib.last (lib.splitString "/" fname)}|g" $BSDSRCDIR/libexec/rc/{${lib.concatStringsSep "," scripts}}'') bins);

  buildPhase = ":";

  installPhase = ''
    install -m 0644 $(eval echo $files) $out/etc
    install -m 0755 $(eval echo $executableFiles) $out/etc
    #install -m 0755 $BSDSRCDIR/libexec/rc/rc.d/* $out/etc/rc.d.default
    #rm $out/etc/rc.d.default/Makefile
  '';
}

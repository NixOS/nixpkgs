{lib, stdenv, mkDerivation, ...}:
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

  installPhase = ''
    install -m 0644 $(eval echo $files) $out/etc
    install -m 0755 $(eval echo $executableFiles) $out/etc
  '';
}

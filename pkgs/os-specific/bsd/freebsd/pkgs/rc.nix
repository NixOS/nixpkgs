{
  mkDerivation,
  lib,
  sysctl,
  bash,
  rcorder,
  bin,
  stat,
  id,
  protect,
  mount,
  fsck,
  logger,
  devmatch,
  sort,
  kldload,
  kldstat,
  devctl,
  sed,
  gnugrep,
}:
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
    fsck
    logger
    devmatch
    sort
    kldload
    kldstat
    devctl
    sed
    gnugrep
  ];
in
mkDerivation {
  path = "libexec/rc";
  MK_TESTS = "no";

  outputs = [
    "out"
    "services"
  ];

  postPatch = ''
    substituteInPlace "$BSDSRCDIR/libexec/rc/Makefile" \
      --replace-fail /etc $out/etc \
      --replace-fail /libexec $out/libexec
    substituteInPlace "$BSDSRCDIR/libexec/rc/rc.d/Makefile" \
      --replace-fail /etc $services/etc \
      --replace-fail /var $services/var
  ''
  + (
    let
      bins = {
        "/sbin/sysctl" = sysctl;
        "/usr/bin/protect" = protect;
        "/usr/bin/id" = id;
        "/bin/ps" = bin;
        "/bin/cpuset" = bin;
        "/usr/bin/stat" = stat;
        "/bin/rm" = bin;
        "/bin/chmod" = bin;
        "/bin/cat" = bin;
        "/bin/sync" = bin;
        "/bin/sleep" = bin;
        "/bin/date" = bin;
        "/usr/bin/logger" = logger;
        "logger" = logger;
        "kenv" = bin;
      };
      scripts = [
        "rc"
        "rc.initdiskless"
        "rc.shutdown"
        "rc.subr"
        "rc.suspend"
        "rc.resume"
        "rc.conf"
      ];
      scriptPaths = "$BSDSRCDIR/libexec/rc/{${lib.concatStringsSep "," scripts}}";
    in
    # set PATH correctly in scripts
    ''
      sed -E -i -e "s|PATH=.*|PATH=${rcDepsPath}|g" ${scriptPaths}
      sed -E -i -e "/etc\/rc.subr/i export PATH=${rcDepsPath}" $BSDSRCDIR/libexec/rc/rc.d/*
    ''
    # replace executable references with nix store filepaths
    + lib.concatMapStringsSep "\n" (
      {
        fname ? name,
        name,
        value,
      }:
      ''
        sed -E -i -e "s|${fname}|${lib.getBin value}/bin/${lib.last (lib.splitString "/" fname)}|g" \
          ${scriptPaths}''
    ) (lib.attrsToList bins)
    + "\n"
  );

  skipIncludesPhase = true;

  postInstall = ''
    makeFlags="$(sed -E -e 's/CONFDIR=[^ ]*//g' <<<"$makeFlags")"
    make $makeFlags installconfig
  '';
}

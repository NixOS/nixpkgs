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
  ];
in
mkDerivation {
  path = "libexec/rc";
  MK_TESTS = "no";

  outputs = [
    "out"
    "services"
  ];

  postPatch =
    ''
      substituteInPlace "$BSDSRCDIR/libexec/rc/Makefile" --replace-fail /etc $out/etc
      substituteInPlace "$BSDSRCDIR/libexec/rc/rc.d/Makefile" \
        --replace-fail /etc $services/etc \
        --replace-fail /var $services/var
    ''
    + (
      let
        bins = [
          "/sbin/sysctl"
          "/usr/bin/protect"
          "/usr/bin/id"
          "/bin/ps"
          "/bin/cpuset"
          "/usr/bin/stat"
          "/bin/rm"
          "/bin/chmod"
          "/bin/cat"
          "/bin/sync"
          "/bin/sleep"
          "/bin/date"
        ];
        scripts = [
          "rc"
          "rc.initdiskless"
          "rc.shutdown"
          "rc.subr"
          "rc.suspend"
          "rc.resume"
        ];
        scriptPaths = "$BSDSRCDIR/libexec/rc/{${lib.concatStringsSep "," scripts}}";
      in
      # set PATH correctly in scripts
      ''
        sed -E -i -e "s|PATH=.*|PATH=${rcDepsPath}|g" ${scriptPaths}
      ''
      # replace executable absolute filepaths with PATH lookups
      + lib.concatMapStringsSep "\n" (fname: ''
        sed -E -i -e "s|${fname}|${lib.last (lib.splitString "/" fname)}|g" \
          ${scriptPaths}'') bins
      + "\n"
    );

  skipIncludesPhase = true;

  postInstall = ''
    makeFlags="$(sed -E -e 's/CONFDIR=[^ ]*//g' <<<"$makeFlags")"
    make $makeFlags installconfig
  '';
}

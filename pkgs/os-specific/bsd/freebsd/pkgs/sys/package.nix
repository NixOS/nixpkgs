{
  stdenv,
  mkDerivation,
  freebsd-lib,
  buildPackages,
  bsdSetupHook,
  freebsdSetupHook,
  makeMinimal,
  install,
  mandoc,
  groff,
  config,
  rpcgen,
  file2c,
  gawk,
  uudecode,
  xargs-j,
}:

mkDerivation (
  let
    cfg = "MINIMAL";
  in
  rec {
    path = "sys";

    nativeBuildInputs = [
      bsdSetupHook
      freebsdSetupHook
      makeMinimal
      install
      mandoc
      groff

      config
      rpcgen
      file2c
      gawk
      uudecode
      xargs-j
    ];

    # --dynamic-linker /red/herring is used when building the kernel.
    NIX_ENFORCE_PURITY = 0;

    AWK = "${buildPackages.gawk}/bin/awk";

    CWARNEXTRA = "-Wno-error=shift-negative-value -Wno-address-of-packed-member";

    MK_CTF = "no";

    KODIR = "${builtins.placeholder "out"}/kernel";
    KMODDIR = "${builtins.placeholder "out"}/kernel";
    DTBDIR = "${builtins.placeholder "out"}/dbt";

    KERN_DEBUGDIR = "${builtins.placeholder "out"}/debug";
    KERN_DEBUGDIR_KODIR = "${KERN_DEBUGDIR}/kernel";
    KERN_DEBUGDIR_KMODDIR = "${KERN_DEBUGDIR}/kernel";

    skipIncludesPhase = true;

    configurePhase = ''
      runHook preConfigure

      for f in conf/kmod.mk contrib/dev/acpica/acpica_prep.sh; do
        substituteInPlace "$f" --replace 'xargs -J' 'xargs-j '
      done

      for f in conf/*.mk; do
        substituteInPlace "$f" --replace 'KERN_DEBUGDIR}''${' 'KERN_DEBUGDIR_'
      done

      cd ${freebsd-lib.mkBsdArch stdenv}/conf
      sed -i ${cfg} \
        -e 's/WITH_CTF=1/WITH_CTF=0/' \
        -e '/KDTRACE/d'
      config ${cfg}

      runHook postConfigure
    '';
    preBuild = ''
      cd ../compile/${cfg}
    '';
  }
)

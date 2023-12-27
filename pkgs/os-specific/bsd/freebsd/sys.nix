{mkDerivation, buildPackages, buildFreebsd, hostArchBsd, patchesRoot, ... }:
mkDerivation (let
    cfg = "GENERIC";
  in rec {
    path = "sys";
    extraPaths = ["include"];

    nativeBuildInputs = (with buildPackages; [
      bsdSetupHook
      mandoc
      groff
      gawk
      #ctfconvert
    ]) ++ (with buildFreebsd; [
      freebsdSetupHook
      bmakeMinimal
      install
      config
      rpcgen
      file2c
      bintrans
      xargs-j
    ]);

    patches = [
      ./sys-gnu-date.patch
      /${patchesRoot}/sys-no-explicit-intrinsics-dep.patch
    ];

    # --dynamic-linker /red/herring is used when building the kernel.
    NIX_ENFORCE_PURITY = 0;

    AWK = "${buildPackages.gawk}/bin/awk";

    CWARNEXTRA = "-Wno-error=shift-negative-value -Wno-address-of-packed-member";

    MK_CTF = "no";
    hardeningDisable = [
      "pic"  # generates relocations the linker can't handle
      "stackprotector"  # generates stack protection for the function generating the stack canary
    ];

    KODIR = "${builtins.placeholder "out"}/kernel";
    KMODDIR = "${builtins.placeholder "out"}/kernel";
    DTBDIR = "${builtins.placeholder"out"}/dbt";

    KERN_DEBUGDIR = "${builtins.placeholder "debug"}/debug";
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

      cd ${hostArchBsd}/conf
      sed -i ${cfg} \
        -e 's/WITH_CTF=1/WITH_CTF=0/' \
        -e '/KDTRACE/d'
      config ${cfg}

      runHook postConfigure
    '';
    preBuild = ''
      cd ../compile/${cfg}
    '';

    outputs = ["out" "debug"];
  })

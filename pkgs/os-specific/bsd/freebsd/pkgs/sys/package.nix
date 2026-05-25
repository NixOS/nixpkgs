{
  lib,
  mkDerivation,
  writeText,
  stdenv,
  buildPackages,
  freebsd-lib,
  patchesRoot,
  filterSource,
  applyPatches,
  baseConfig ? "GENERIC",
  extraConfig ? null,
  extraFlags ? { },
  bsdSetupHook,
  mandoc,
  groff,
  gawk,
  freebsdSetupHook,
  makeMinimal,
  install,
  config,
  rpcgen,
  file2c,
  bintrans,
  xargs-j,
  kldxref,
  ctfconvert,
  ctfmerge,
}:
let
  baseConfigFile =
    if (extraConfig == null) then
      null
    else if (lib.isDerivation extraConfig) || (lib.isPath extraConfig) then
      extraConfig
    else
      writeText "extraConfig" extraConfig;
  hostArchBsd = freebsd-lib.mkBsdArch stdenv;
  filteredSource = filterSource {
    pname = "sys";
    path = "sys";
    extraPaths = [ "include" ];
  };
  patchedSource = applyPatches {
    src = filteredSource;
    patches = freebsd-lib.filterPatches patchesRoot [
      "sys"
      "include"
    ];
    postPatch = ''
      for f in sys/contrib/dev/acpica/acpica_prep.sh; do
        substituteInPlace "$f" --replace-warn 'xargs -J' 'xargs-j '
      done

      for f in sys/conf/*.mk; do
        substituteInPlace "$f" --replace-quiet 'KERN_DEBUGDIR}''${' 'KERN_DEBUGDIR_'
      done
    ''
    + lib.optionalString (baseConfigFile != null) ''
      cat ${baseConfigFile} >>sys/${hostArchBsd}/conf/${baseConfig}
    '';
  };

  # Kernel modules need this for kern.opts.mk
  env = lib.flip lib.mapAttrs' extraFlags (
    name: value: {
      name = "MK_${lib.toUpper name}";
      value = lib.boolToYesNo value;
    }
  );
in
mkDerivation rec {
  pname = "sys";

  # Patch source outside of this derivation so out-of-tree modules can use it
  src = patchedSource;
  path = "sys";
  autoPickPatches = false;

  nativeBuildInputs = [
    bsdSetupHook
    mandoc
    groff
    gawk
    freebsdSetupHook
    makeMinimal
    install
    config
    rpcgen
    file2c
    bintrans
    xargs-j
    kldxref
    ctfconvert
    ctfmerge
  ];

  # --dynamic-linker /red/herring is used when building the kernel.
  NIX_ENFORCE_PURITY = 0;

  AWK = "${buildPackages.gawk}/bin/awk";

  CWARNEXTRA = "-Wno-error=shift-negative-value -Wno-address-of-packed-member";

  hardeningDisable = [
    "pic" # generates relocations the linker can't handle
    "stackprotector" # generates stack protection for the function generating the stack canary
  ];

  # hardeningDisable = stackprotector doesn't seem to be enough, put it in cflags too
  NIX_CFLAGS_COMPILE = [
    "-fno-stack-protector"
    "-Wno-unneeded-internal-declaration" # some openzfs code trips this
    "-Wno-default-const-init-field-unsafe" # added in clang 21
    "-Wno-uninitialized-const-pointer" # added in clang 21
    "-Wno-format" # error: passing 'printf' format string where 'freebsd_kprintf' format string is expected
    "-Wno-sometimes-uninitialized" # this one is actually kind of concerning but it does trip
    "-Wno-unused-function"
  ];

  inherit env;
  passthru.env = env;

  makeFlags = [ "XARGS_J=xargs-j" ];

  KODIR = "${placeholder "out"}/kernel";
  KMODDIR = "${placeholder "out"}/kernel";
  DTBDIR = "${placeholder "out"}/dbt";

  KERN_DEBUGDIR = "${placeholder "debug"}/lib/debug";
  KERN_DEBUGDIR_KODIR = "${KERN_DEBUGDIR}/kernel";
  KERN_DEBUGDIR_KMODDIR = "${KERN_DEBUGDIR}/kernel";

  skipIncludesPhase = true;

  configurePhase = ''
    runHook preConfigure

    cd ${hostArchBsd}/conf
    config ${baseConfig}

    runHook postConfigure
  '';
  preBuild = ''
    cd ../compile/${baseConfig}
  '';

  outputs = [
    "out"
    "debug"
  ];

  meta = {
    description = "FreeBSD kernel and modules";
    platforms = lib.platforms.freebsd;
  };
}

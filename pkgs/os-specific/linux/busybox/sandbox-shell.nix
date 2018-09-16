{ busybox, stdenv}:

# Minimal shell for use as basic /bin/sh in sandbox builds
busybox.override {
  # musl roadmap has RISC-V support projected for 1.1.20
  useMusl = !stdenv.hostPlatform.isRiscV;
  enableStatic = true;
  enableMinimal = true;
  extraConfig = ''
    CONFIG_FEATURE_FANCY_ECHO y
    CONFIG_FEATURE_SH_MATH y
    CONFIG_FEATURE_SH_MATH_64 y

    CONFIG_ASH y
    CONFIG_ASH_OPTIMIZE_FOR_SIZE y

    CONFIG_ASH_ALIAS y
    CONFIG_ASH_BASH_COMPAT y
    CONFIG_ASH_CMDCMD y
    CONFIG_ASH_ECHO y
    CONFIG_ASH_GETOPTS y
    CONFIG_ASH_INTERNAL_GLOB y
    CONFIG_ASH_JOB_CONTROL y
    CONFIG_ASH_PRINTF y
    CONFIG_ASH_TEST y
  '';
}

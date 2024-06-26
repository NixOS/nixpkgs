{
  makeSetupHook,
  writeText,
  stat,
}:

# stat isn't in POSIX, and NetBSD stat supports a completely
# different range of flags than GNU stat, so including it in PATH
# breaks stdenv.  Work around that with a hook that will point
# NetBSD's build system and NetBSD stat without including it in
# PATH.
makeSetupHook { name = "netbsd-stat-hook"; } (
  writeText "netbsd-stat-hook-impl" ''
    makeFlagsArray+=(TOOL_STAT=${stat}/bin/stat)
  ''
)

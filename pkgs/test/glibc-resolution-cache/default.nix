# End-to-end test of the glibc DT_NEEDED resolution cache (issue #481620).
#
# It exercises both halves of the feature exactly as they ship:
#   * the default patchelf writes the .note.nixos.ldcache note, and
#   * the default glibc (patched with ./ldcache.patch) reads it.
#
# Rather than hand-driving patchelf, this builds an ordinary stdenv package and
# lets the standard fixup hooks -- including generate-ld-cache -- write the note
# during the build, just like for every other package; the binary's interpreter
# is the default (patched) loader. A second, identical package built with
# `dontGenerateLDCache` is the no-note control.
#
# The program needs two libraries, libbar and libfoo, kept in separate RUNPATH
# directories (dep/ before real/). libbar lives in dep/ and libfoo in real/, so
# both directories survive RPATH shrinking (each holds a needed library) yet the
# loader still genuinely probes dep/ for libfoo before finding it in real/. This
# mirrors the real stat-storm: a long RUNPATH walked once per needed library.
#
# The patched loader must resolve libfoo straight from the note without probing
# dep/; the control (no note) must still probe it; and LD_LIBRARY_PATH must
# still override the cached path. Behaviour is observed via LD_DEBUG=libs, so no
# ptrace is required in the build sandbox.

{
  lib,
  stdenv,
  runCommand,
  binutils,
}:

let
  # An ordinary stdenv build. Nothing here is specific to the cache: the note
  # (when enabled) is written by the normal fixup hooks, and the interpreter is
  # whatever the default stdenv uses.
  mkProg =
    { generateCache }:
    stdenv.mkDerivation {
      name = "ld-cache-${if generateCache then "cached" else "control"}";
      dontUnpack = true;
      dontGenerateLDCache = !generateCache;
      buildPhase = ''
        runHook preBuild

        mkdir -p $out/bin $out/lib/dep $out/lib/real $out/lib/over
        printf '%s\n' 'int bar(void) { return 1; }' > bar.c
        printf '%s\n' 'int foo(void) { return 7; }' > foo.c
        printf '%s\n' 'int foo(void) { return 42; }' > foo_over.c
        printf '%s\n' \
          'extern int foo(void); extern int bar(void);' \
          'int main(void) { return foo() + bar() - 1; }' > main.c

        $CC -shared -fPIC -Wl,-soname,libbar.so.1 -o $out/lib/dep/libbar.so.1 bar.c
        ln -s libbar.so.1 $out/lib/dep/libbar.so
        $CC -shared -fPIC -Wl,-soname,libfoo.so.1 -o $out/lib/real/libfoo.so.1 foo.c
        ln -s libfoo.so.1 $out/lib/real/libfoo.so
        # Override copy returning 42, used to prove LD_LIBRARY_PATH still wins.
        $CC -shared -fPIC -Wl,-soname,libfoo.so.1 -o $out/lib/over/libfoo.so.1 foo_over.c

        # RUNPATH dep/ (libbar, no libfoo) precedes real/ (libfoo). Both survive
        # RPATH shrinking, so the loader genuinely probes dep/ for libfoo first.
        $CC main.c -o $out/bin/prog \
          -L$out/lib/dep -lbar -L$out/lib/real -lfoo \
          -Wl,--enable-new-dtags -Wl,-rpath,"$out/lib/dep:$out/lib/real"

        runHook postBuild
      '';
    };

  cached = mkProg { generateCache = true; };
  control = mkProg { generateCache = false; };
in
runCommand "glibc-resolution-cache-test"
  {
    inherit cached control;
    nativeBuildInputs = [ binutils ]; # readelf
    meta = {
      description = "End-to-end test of the glibc DT_NEEDED resolution cache note";
      maintainers = with lib.maintainers; [ domenkozar ];
      platforms = lib.platforms.linux;
    };
  }
  ''
    prog="$cached/bin/prog"
    prog_nonote="$control/bin/prog"

    echo "[test] the fixup hook wrote the note resolving libfoo.so.1 to real/"
    readelf -p .note.nixos.ldcache "$prog" | grep -q "$cached/lib/real/libfoo.so.1"

    echo "[test] the control binary has no note"
    if readelf -p .note.nixos.ldcache "$prog_nonote" 2>/dev/null | grep -q libfoo; then
      echo "  unexpected note in control binary" >&2
      exit 1
    fi

    # Count the loader probing dep/ for libfoo (the dir that lacks it).
    probes() { LD_DEBUG=libs "$1" 2>&1 >/dev/null | grep -cE 'trying file=.*/lib/dep/libfoo\.so\.1' || true; }

    echo "[test] with the note, the loader does not probe dep/ for libfoo"
    n=$(probes "$prog")
    echo "  dep/ probes (note):    $n"
    [ "$n" -eq 0 ]

    echo "[test] without the note, the same loader does probe it (control)"
    c=$(probes "$prog_nonote")
    echo "  dep/ probes (no note): $c"
    [ "$c" -gt 0 ]

    echo "[test] the program runs and resolves the real library (returns 7)"
    rc=0
    "$prog" || rc=$?
    [ "$rc" -eq 7 ]

    echo "[test] LD_LIBRARY_PATH still overrides the note (returns 42)"
    rc=0
    LD_LIBRARY_PATH="$cached/lib/over" "$prog" || rc=$?
    [ "$rc" -eq 42 ]

    echo "[test] PASS"
    touch "$out"
  ''

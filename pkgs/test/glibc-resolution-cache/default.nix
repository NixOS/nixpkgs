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
# still override the cached path. A second fixture reintroduces a
# runtime-dependent RUNPATH component (an empty entry, meaning the caller's
# current directory) in postFixup, before generate-ld-cache writes the note; the
# loader must ignore the exact cache entry in that case so normal RUNPATH
# ordering still applies. Behaviour is observed via LD_DEBUG=libs, so no ptrace
# is required in the build sandbox.
#
# A third fixture bakes a RUNPATH whose first directory does not exist while
# the note is generated (the /run/opengl-driver/lib pattern): patchelf must
# record it as a "?" search hint rather than drop it, so the loader still
# probes it at run time. This test populates that directory afterwards with an
# overriding libfoo and asserts the override wins over the note's exact real/
# entry. The fixture relies on the sandbox build root being /build for both
# the fixture build and this test, like the LD_DEBUG assumption above.

{
  lib,
  stdenv,
  runCommand,
  binutils,
  patchelf,
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
      nativeBuildInputs = [ patchelf ];
      buildPhase = ''
        runHook preBuild

        mkdir -p $out/bin $out/lib/dep $out/lib/real $out/lib/over
        printf '%s\n' 'int bar(void) { return 1; }' > bar.c
        printf '%s\n' 'int foo(void) { return 7; }' > foo.c
        printf '%s\n' 'int foo(void) { return 42; }' > foo_over.c
        printf '%s\n' \
          'extern int foo(void); extern int bar(void);' \
          'int main(void) { return foo() + bar() - 1; }' > main.c
        printf '%s\n' \
          'extern int foo(void);' \
          'int main(void) { return foo(); }' > main_foo.c

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

        $CC main_foo.c -o $out/bin/prog-cwd \
          -L$out/lib/real -lfoo \
          -Wl,--enable-new-dtags -Wl,-rpath,"$out/lib/real"

        $CC main_foo.c -o $out/bin/prog-runtime \
          -L$out/lib/real -lfoo \
          -Wl,--enable-new-dtags -Wl,-rpath,"$out/lib/real"

        runHook postBuild
      '';
      postFixup = ''
        # Reintroduce an empty RUNPATH component after normal shrinkage but
        # before generate-ld-cache runs from postFixupHooks. Without the glibc
        # guard, the note's exact real/ entry bypasses this earlier runtime
        # search path.
        patchelf --set-rpath ":$out/lib/real" "$out/bin/prog-cwd"

        # Prepend a directory that does not exist while the note is generated
        # (RPATH shrinking would drop it from the link-time RUNPATH, hence the
        # rewrite here). patchelf must record it as a "?" search hint; the
        # outer test creates it under the shared sandbox build root /build and
        # proves a library placed there at run time wins over the note's exact
        # real/ entry.
        patchelf --set-rpath "/build/ld-cache-runtime-libs:$out/lib/real" "$out/bin/prog-runtime"
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
    prog_cwd="$cached/bin/prog-cwd"
    prog_nonote="$control/bin/prog"

    echo "[test] the fixup hook wrote the note resolving libfoo.so.1 to real/"
    readelf -p .note.nixos.ldcache "$prog" | grep -q "$cached/lib/real/libfoo.so.1"
    readelf -p .note.nixos.ldcache "$prog_cwd" | grep -q "$cached/lib/real/libfoo.so.1"

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

    echo "[test] LD_DEBUG names the note as the source (trying cached file=)"
    # prog exits 7 by design; guard it or pipefail fails the pipeline.
    { LD_DEBUG=libs "$prog" 2>&1 >/dev/null || true; } \
      | grep -qF "trying cached file=$cached/lib/real/libfoo.so.1"

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

    echo "[test] the fixture keeps an empty (current directory) RUNPATH component"
    if ! readelf -d "$prog_cwd" | grep RUNPATH | grep -qE '\[:|::|:]'; then
      echo "  expected an empty RUNPATH component" >&2
      exit 1
    fi

    echo "[test] an earlier current-directory RUNPATH component still wins"
    cp "$cached/lib/over/libfoo.so.1" ./libfoo.so.1
    rc=0
    "$prog_cwd" || rc=$?
    [ "$rc" -eq 42 ]

    prog_runtime="$cached/bin/prog-runtime"

    echo "[test] the note records the build-time-missing dir as a '?' search hint"
    readelf -p .note.nixos.ldcache "$prog_runtime" | grep -qF "?/build/ld-cache-runtime-libs"

    echo "[test] with the runtime dir still absent, the exact entry resolves (returns 7)"
    rc=0
    "$prog_runtime" || rc=$?
    [ "$rc" -eq 7 ]

    echo "[test] a dir populated after note generation wins over the exact entry (returns 42)"
    mkdir -p /build/ld-cache-runtime-libs
    cp "$cached/lib/over/libfoo.so.1" /build/ld-cache-runtime-libs/
    rc=0
    "$prog_runtime" || rc=$?
    [ "$rc" -eq 42 ]

    echo "[test] the control binary agrees (stock RUNPATH semantics, returns 42)"
    rc=0
    "$control/bin/prog-runtime" || rc=$?
    [ "$rc" -eq 42 ]

    echo "[test] PASS"
    touch "$out"
  ''

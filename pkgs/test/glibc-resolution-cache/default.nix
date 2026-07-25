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
# probes it at run time. A companion fixture covers an existing but mutable
# absolute directory. Patchelf 0.19.1 emits no "?" hint for that case when the
# soname is absent, so glibc must decline the cache for any non-store RUNPATH
# and preserve first-match semantics if the directory is populated later.
# Both fixtures rely on the sandbox build root being /build for the fixture
# build and this test, like the LD_DEBUG assumption above.
#
# A fourth fixture links a hand-crafted note whose descriptor is a bare
# "\0\0", i.e. an empty pair sequence, something patchelf never emits (it
# writes no note at all when it has nothing to record). The loader must treat
# it as an empty cache: no hits, graceful fallback to the normal RUNPATH walk,
# and the program still runs. Because the linker (not patchelf) places this
# note, it lands in the 4-aligned PT_NOTE segment next to .note.ABI-tag, so it
# also exercises the reader stepping over a foreign note inside one segment.
#
# That fixture needs its own package, built with both dontGenerateLDCache (the
# note hook rightly fails a build whose binary already carries a note with a
# different descriptor) and dontPatchELF, because patchelf --shrink-rpath
# deletes a .note.nixos.ldcache it did not itself write and runs before the
# note hook. Keeping it out of the control package leaves that package running
# exactly the fixups the cached one does.

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
    {
      generateCache,
      craftedNote ? false,
    }:
    stdenv.mkDerivation {
      name = "ld-cache-${
        if generateCache then
          "cached"
        else if craftedNote then
          "crafted"
        else
          "control"
      }";
      dontUnpack = true;
      dontGenerateLDCache = !generateCache;
      # patchelf --shrink-rpath deletes any .note.nixos.ldcache it finds,
      # treating a note it did not just write as stale, and it runs from
      # fixupOutput, before the note hook. That is harmless for real packages
      # (their note is written afterwards, in postFixup) but it would strip a
      # note placed by the linker before this fixture ever runs, leaving a
      # binary that silently tests nothing. Skip that pass here only.
      dontPatchELF = craftedNote;
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

        $CC main_foo.c -o $out/bin/prog-mutable \
          -L$out/lib/real -lfoo \
          -Wl,--enable-new-dtags -Wl,-rpath,"$out/lib/real"

        ${lib.optionalString craftedNote ''
          # A well-formed note (padded to the 4-byte boundary, so readelf and
          # the loader agree on where it ends) whose descriptor is just the
          # end-of-sequence NUL plus one more: an empty cache.
          printf '%s\n' \
            '.section .note.nixos.ldcache, "a", %note' \
            '.balign 4' \
            '.long 6' \
            '.long 2' \
            '.long 0x63a86cb6' \
            '.ascii "NixOS\0"' \
            '.balign 4' \
            '.byte 0, 0' \
            '.balign 4' \
            '.section .note.GNU-stack, "", %progbits' > empty-note.s
          $CC main.c empty-note.s -o $out/bin/prog-empty \
            -L$out/lib/dep -lbar -L$out/lib/real -lfoo \
            -Wl,--enable-new-dtags -Wl,-rpath,"$out/lib/dep:$out/lib/real"

          # Native helper used by the outer test to corrupt PT_NOTE p_align
          # values without depending on the ELF class of the test platform.
          printf '%s\n' \
            '#include <elf.h>' \
            '#include <fcntl.h>' \
            '#include <stdio.h>' \
            '#include <unistd.h>' \
            '#if __SIZEOF_POINTER__ == 8' \
            'typedef Elf64_Ehdr Ehdr;' \
            'typedef Elf64_Phdr Phdr;' \
            '#define NATIVE_CLASS ELFCLASS64' \
            '#else' \
            'typedef Elf32_Ehdr Ehdr;' \
            'typedef Elf32_Phdr Phdr;' \
            '#define NATIVE_CLASS ELFCLASS32' \
            '#endif' \
            'int main(int argc, char **argv) {' \
            '  if (argc != 2) return 2;' \
            '  int fd = open(argv[1], O_RDWR);' \
            '  Ehdr eh;' \
            '  if (fd < 0 || pread(fd, &eh, sizeof eh, 0) != sizeof eh' \
            '      || eh.e_ident[EI_CLASS] != NATIVE_CLASS' \
            '      || eh.e_phentsize != sizeof(Phdr)) return 2;' \
            '  int changed = 0;' \
            '  for (unsigned int i = 0; i < eh.e_phnum; ++i) {' \
            '    off_t off = eh.e_phoff + (off_t) i * eh.e_phentsize;' \
            '    Phdr ph;' \
            '    if (pread(fd, &ph, sizeof ph, off) != sizeof ph) return 2;' \
            '    if (ph.p_type == PT_NOTE) {' \
            '      ph.p_align = -1;' \
            '      if (pwrite(fd, &ph, sizeof ph, off) != sizeof ph) return 2;' \
            '      changed = 1;' \
            '    }' \
            '  }' \
            '  if (close(fd) != 0) return 2;' \
            '  return changed ? 0 : 1;' \
            '}' > corrupt-note-align.c
          $CC -Wall -Wextra -Werror -o $out/bin/corrupt-note-align corrupt-note-align.c
        ''}

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

        # Unlike prog-runtime's missing directory, this directory exists when
        # patchelf builds the note. patchelf therefore records neither a "?"
        # hint nor a miss for it. The loader must still search it at run time
        # because an absolute non-store directory is mutable.
        mkdir -p /build/ld-cache-existing-libs
        patchelf --set-rpath "/build/ld-cache-existing-libs:$out/lib/real" "$out/bin/prog-mutable"
      '';
    };

  cached = mkProg { generateCache = true; };
  control = mkProg { generateCache = false; };
  # Separate from `control` so that `control` keeps running exactly the fixups
  # `cached` does, which is what makes it a fair comparison; only this fixture
  # needs the shrink-rpath pass skipped.
  crafted = mkProg {
    generateCache = false;
    craftedNote = true;
  };
in
runCommand "glibc-resolution-cache-test"
  {
    inherit cached control crafted;
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

    prog_mutable="$cached/bin/prog-mutable"

    echo "[test] patchelf records no search hint for an existing mutable directory"
    readelf -p .note.nixos.ldcache "$prog_mutable" \
      | grep -qF "=$cached/lib/real/libfoo.so.1"
    if readelf -p .note.nixos.ldcache "$prog_mutable" \
        | grep -qF "?/build/ld-cache-existing-libs"; then
      echo "  unexpected search hint for existing mutable directory" >&2
      exit 1
    fi

    echo "[test] a mutable directory populated later still wins (returns 42)"
    mkdir -p /build/ld-cache-existing-libs
    cp "$cached/lib/over/libfoo.so.1" /build/ld-cache-existing-libs/
    rc=0
    "$prog_mutable" || rc=$?
    [ "$rc" -eq 42 ]

    echo "[test] the mutable-directory control agrees (returns 42)"
    rc=0
    "$control/bin/prog-mutable" || rc=$?
    [ "$rc" -eq 42 ]

    prog_empty="$crafted/bin/prog-empty"

    # Without this the rest of the empty-note block is satisfied just as well by
    # a binary that has no note at all, which is exactly what shrink-rpath used
    # to leave behind. The reader only walks PT_NOTE segments, so being an
    # SHT_NOTE section is not enough: require the section to be mapped by one.
    echo "[test] the linker-placed note survived the build and sits in a PT_NOTE"
    readelf -lW "$prog_empty" | awk '
      /^ +Type +Offset/            { inph = 1; idx = 0; next }
      inph && NF == 0              { inph = 0 }
      inph && $1 ~ /^[A-Z_]+$/     { if ($1 == "NOTE") note[sprintf("%02d", idx)] = 1; idx++ }
      /Section to Segment mapping/ { inmap = 1; next }
      inmap && ($1 in note)        { if (index($0, ".note.nixos.ldcache")) found = 1 }
      END                          { exit found ? 0 : 1 }
    '

    echo "[test] the crafted note carries an empty two-NUL descriptor"
    readelf -n "$prog_empty" | grep NixOS | grep -q 0x00000002

    echo "[test] an empty note is harmless: the loader falls back to the RUNPATH walk"
    e=$(probes "$prog_empty")
    echo "  dep/ probes (empty note): $e"
    [ "$e" -gt 0 ]

    echo "[test] an empty note never produces a cache hit"
    if { LD_DEBUG=libs "$prog_empty" 2>&1 >/dev/null || true; } \
        | grep -q "trying cached file="; then
      echo "  unexpected cache hit with an empty note" >&2
      exit 1
    fi

    echo "[test] the program with the empty note still runs (returns 7)"
    rc=0
    "$prog_empty" || rc=$?
    [ "$rc" -eq 7 ]

    echo "[test] a malformed non-power-of-two PT_NOTE alignment cannot hang the loader"
    cp "$prog" ./prog-bad-note-align
    chmod u+w ./prog-bad-note-align
    "$crafted/bin/corrupt-note-align" ./prog-bad-note-align
    rc=0
    timeout 5 ./prog-bad-note-align || rc=$?
    [ "$rc" -eq 7 ]

    echo "[test] PASS"
    touch "$out"
  ''

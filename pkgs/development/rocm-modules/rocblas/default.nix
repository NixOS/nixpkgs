# rocBLAS per-arch Tensile shard split (P-A) — F8, SPLIT-OPTIONS.md §8.
#
# WHY THIS IS SAFE (verified against therock-10.0 rocm-libraries source + a built
# gfx906 output, SPLIT-OPTIONS.md §8.7):
#   rocBLAS builds Tensile with SEPARATE_ARCHITECTURES + LAZY_LIBRARY_LOADING (both on
#   in base.nix), which emit one SELF-CONTAINED directory per gfx into
#   `lib/rocblas/library/<gfx>/` — each carrying its own `TensileLibrary_lazy_<gfx>.dat`
#   index plus that arch's `.co`/`.dat`/`.hsaco` code objects, and nothing else.
#   In a SHARED build the kernels are NOT linked into librocblas.so: merge_archives.py
#   runs only for `NOT BUILD_SHARED_LIBS` (library/src/CMakeLists.txt:792). At runtime
#   the .so opens `library/<arch>/TensileLibrary_lazy_<arch>.dat` by path
#   (TensileManifest.txt is deliberately excluded; nothing reads a global index).
#   => a .so built for ONE arch loads any OTHER arch's directory dropped in beside it,
#      so the join is a plain per-arch-dir MERGE: no relink, no shared-index reconcile.
#
# STRUCTURE (mirrors composable_kernel's base.nix + default.nix op-shard, but on the
# ARCH axis and data-style instead of object-relink):
#   * `mkTensileShard arch` — base built with GPU_TARGETS=[<gfx>], keeping only
#     `lib/rocblas/library/<gfx>/`. A code change to one arch rebuilds one shard.
#   * the join builds librocblas.so + headers + cmake ONCE (for the head arch) and
#     merges every other arch's shard dir in postInstall.
#   * P-J invariant: consumers see one `rocblas` attr, identical $out layout, and
#     `passthru.amdgpu_targets` = the FULL arch list (not just the head).
#
# BUILD-VERIFY PENDING (F8 §8.7 measurement-first gate — run on l2 once it is idle):
#   (a) runtime: confirm a head-arch-built .so lazy-loads a MERGED non-head arch dir on
#       real hardware (the one assumption the source strongly implies but only a run
#       proves). Table-driven check in §8.7.
#   (b) P-J: `nix derivation show` the joined output pre/post split is identical except
#       the (private) shard inputs; consumer input-drv hashes unchanged.
#   (c) fixed cost: the head arch's kernels are recompiled every time the join re-runs.
#       A zero-arch host (.so with NO Tensile compile) would remove it, but needs an
#       experiment: does TensileCreateLibraryFiles accept an empty ARCHITECTURE, and
#       does `librocblas.so` link without TENSILE_LIBRARY_TARGET? Draft keeps a head
#       arch for correctness; optimise after measuring.
#   (d) shard waste: each shard currently builds the full .so then discards it. A
#       `makeFlags = [ "TENSILE_LIBRARY_TARGET" ]`-style restriction (cf. CK makeTargets)
#       would build only the kernels. Left out of the draft (correctness first).
#   (e) `disallowedReferences` on the shards is the P-J tightening; if a merged code
#       object turns out to embed a shard store path, drop it (checked in (b)).
{
  lib,
  clr,
  rocblas_base,
}:

let
  archList = clr.localGpuTargets or clr.gpuTargets;
  headArch = lib.head archList;
  tailArchs = lib.drop 1 archList;

  # One self-contained per-arch Tensile library shard. Built from the base for a
  # single gfx; everything but `lib/rocblas/library/<arch>/` is dropped so the shard
  # is small and holds only the per-arch data the join merges.
  mkTensileShard =
    arch:
    (rocblas_base.override {
      gpuTargets = [ arch ];
      buildTests = false;
      buildBenchmarks = false;
    }).overrideAttrs
      (old: {
        pname = "rocblas-tensile-${arch}";
        outputs = [ "out" ];
        doCheck = false;
        # Keep ONLY the per-arch Tensile library directory.
        postInstall = (old.postInstall or "") + ''
          keep="$(mktemp -d)"
          cp -r "$out/lib/rocblas/library" "$keep/library"
          rm -rf "$out"/*
          mkdir -p "$out/lib/rocblas"
          mv "$keep/library" "$out/lib/rocblas/library"
          rm -rf "$keep"
        '';
      });

  tensileShards = map mkTensileShard tailArchs;
in

# Single-arch scopes (e.g. rocmPackages.gfx906.*, the primary MI50 dev loop) have no
# tail archs, so the split is a pure no-op there: return the un-split base build
# verbatim so its derivation stays BYTE-IDENTICAL to pre-split (no needless rebuild of
# an already-cached narrowed rocblas, and the strongest possible P-J guarantee for the
# common dev case). Sharding only takes effect for the multi-arch PR matrix.
if tailArchs == [ ] then
  rocblas_base.override { gpuTargets = archList; }
else

# The public rocBLAS: host .so + headers + cmake built once for the head arch, with
# every other arch's Tensile library merged in. Identical layout + passthru to the
# un-split build (P-J).
(rocblas_base.override {
  gpuTargets = [ headArch ];
}).overrideAttrs
  (old: {
    pname = "rocblas${clr.gpuArchSuffix}";

    # Referenced (space-separated store paths) in postInstall; declaring them here
    # makes them build inputs of the join.
    tensileShards = tensileShards;
    disallowedReferences = tensileShards;

    # After the normal (head-arch) install, merge each tail arch's shard dir so
    # lib/rocblas/library/ ends up with a self-contained subdir per requested arch.
    #
    # Then strip the shard store paths that Tensile bakes into a per-arch code
    # object's ELF metadata (empirically one `.co` per arch, e.g.
    # `TensileLibrary_Type_BB_HPA_Contraction_..._gfxNNNN.co`). This reference is
    # NOT load-bearing — the un-split multi-arch build embeds its own `$out` in the
    # same spot as a permitted self-reference and runs fine; the GPU code loader
    # reads the kernel image, never this string. Without the strip the joined output
    # refers to the private per-arch shards (caught by `disallowedReferences` below),
    # which would drag every shard into consumers' closures. `remove-references-to`
    # does an equal-length hash substitution, so the ELF stays byte-aligned and the
    # kernels are unaffected. base.nix already uses it (for `tensile`), so
    # `removeReferencesTo` is on PATH here via the inherited nativeBuildInputs.
    postInstall = (old.postInstall or "") + ''
      for shard in $tensileShards; do
        cp -r --no-preserve=mode "$shard/lib/rocblas/library/"* "$out/lib/rocblas/library/"
      done
      for shard in $tensileShards; do
        find "$out/lib/rocblas/library" -type f -exec remove-references-to -t "$shard" {} +
      done
    '';

    passthru = (old.passthru or { }) // {
      # Consumers must see the FULL arch set, not just the head the .so was built for.
      amdgpu_targets = lib.concatStringsSep ";" archList;
      tensileShards = tensileShards;
    };
  })

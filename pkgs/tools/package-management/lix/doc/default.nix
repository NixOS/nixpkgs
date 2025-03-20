{
  lib,
  src,
  rustPlatform,
  version,
  cargoDeps,
  docSourceRoot,
}:

rustPlatform.buildRustPackage (
  {
    pname = "lix-doc";
    inherit
      version
      src
      cargoDeps
      ;
  }
  // (
    # Lix 2.92 and above has a Cargo workspace described in `Cargo.toml`. This
    # means that even though the `lix-doc` crate is in `docSourceRoot`, the
    # `Cargo.lock` is in the top-level source directory.
    #
    # In earlier versions, the `Cargo.lock` is in `docSourceRoot` directly, so
    # we use that as the `sourceRoot`.
    if lib.versionAtLeast version "2.92" then
      {
        buildAndTestSubdir = docSourceRoot;
      }
    else
      {
        sourceRoot = "${src.name or src}/${docSourceRoot}";
      }
  )
)

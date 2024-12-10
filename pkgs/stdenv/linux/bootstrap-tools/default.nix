{
  system,
  bootstrapFiles,
  extraAttrs,
}:

derivation (
  {
    name = "bootstrap-tools";

    builder = bootstrapFiles.busybox;

    args = [
      "ash"
      "-e"
      ./scripts/unpack-bootstrap-tools.sh
    ];

    tarball = bootstrapFiles.bootstrapTools;

    inherit system;

    # Needed by the GCC wrapper.
    langC = true;
    langCC = true;
    isGNU = true;
    hardeningUnsupportedFlags = [
      "fortify3"
      "zerocallusedregs"
      "trivialautovarinit"
    ];
  }
  // extraAttrs
)

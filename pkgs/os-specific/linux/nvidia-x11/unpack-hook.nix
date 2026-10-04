# Unpacks the `.run` driver installer, which `unpackPhase` cannot handle on its
# own. Both the userspace libraries and the kernel modules are built from that
# archive, so they share this hook.
{
  makeSetupHook,
  # Tools the Makeself preamble drives to extract itself. It picks its
  # decompressor at runtime: `zstd` since 530.30.02, `gzip`/`bzip2`/`xz` before.
  bzip2,
  gawk,
  gnused,
  gzip,
  # Provides `bsdtar` for the fallback path in the hook.
  libarchive,
  gnutar,
  xz,
  zstd,
}:

makeSetupHook {
  name = "nvidia-driver-unpack-hook";

  propagatedBuildInputs = [
    bzip2
    gawk
    gnused
    gzip
    libarchive
    gnutar
    xz
    zstd
  ];
} ./unpack-hook.sh
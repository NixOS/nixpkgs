# Unpacks the NVIDIA driver installer, a Makeself archive that `unpackPhase`
# cannot handle on its own. Both the userspace libraries and the proprietary
# kernel module are built from it, so they share this hook.
{
  makeSetupHook,
  # What the Makeself preamble runs, checked against the 595 and Vulkan-beta
  # installers: `cksum`/`cut`/`tail`/`head` come from coreutils, the rest here.
  gawk,
  gnused,
  gnutar,
  # `bsdtar` for the fallback path in the hook. It detects the compression
  # itself, so an archive needing `gzip`, `bzip2` or `xz` as a separate program
  # is still unpacked that way.
  libarchive,
  # Older Makeself releases, which the 340-470 drivers ship, locate their
  # helpers with `which`.
  which,
  # The decompressor since 530.30.02; earlier installers ship their own.
  zstd,
}:

makeSetupHook {
  name = "nvidia-driver-unpack-hook";

  propagatedBuildInputs = [
    gawk
    gnused
    gnutar
    libarchive
    which
    zstd
  ];
} ./unpack-hook.sh

# The Mingw-w64 toolchain
# =======================
#
# The mingw-w64 toolchain provides whas is essentially the msvcrt (libc for windows).
# It comes in the following components:
# - headers. These proivde the basic headers needed to build against the msvcrt.
# - msvcrt. The libc itself (headers + lirbary)
# - winpthreads. A pthreads implementation for windows. This is notably required
#   to allow GCC to use the posix thread-model, which is an essential requirement
#   for c++11 support in GCC.
#
# Installation instructions can be found at
# https://sourceforge.net/p/mingw-w64/wiki2/Cross%20Win32%20and%20Win64%20compiler/
#
# Note: while the installation instruction explicitly state that we need to place
#       the headers and crt into <target> as of v3. This does not seem to be acurate
#       anymore.  As nix CC wrapper picks up the ~include~ folder from ~$out~, we will
#       use just ~$out~ instead of ~$out/x86_64-w64-mingw~.
#
{ fetchurl }:

rec {
  version = "5.0.3";
  name = "mingw-w64-${version}";

  src = fetchurl {
    url = "http://cfhcable.dl.sourceforge.net/project/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v${version}.tar.bz2";
    sha256 = "1d4wrjfdlq5xqpv9zg6ssw4lm8jnv6522xf7d6zbjygmkswisq1a";
  };
}

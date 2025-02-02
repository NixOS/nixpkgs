{ mkDerivation, ... }:
# this package is quite different from stock libcxxrt.
# as of FreeBSD 14.0, it is vendored from APPROXIMATELY libcxxrt
# 5d8a15823a103bbc27f1bfdcf2b5aa008fab57dd, though the vendoring mechanism is
# extremely ad-hoc. Moreover, the build mechanism is totally custom, and adds
# symbol versions not specified on any version of libcxxrt.
mkDerivation {
  pname = "libcxxrt";
  path = "lib/libcxxrt";
  extraPaths = [ "contrib/libcxxrt" ];
}

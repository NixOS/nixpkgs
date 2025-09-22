{ mkDerivation }:
mkDerivation {
  path = "lib/libstdthreads";
  extraPaths = [ "lib/libc/Versions.def" ];
}

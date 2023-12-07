{ mkDerivation, libc, libcapsicum, libcasper, ...}:
mkDerivation {
  path = "usr.bin/iconv";
  buildInputs = [libc libcapsicum libcasper];
}

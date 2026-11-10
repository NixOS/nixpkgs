{ lib, mkDerivation }:

mkDerivation {
  path = "lib/libcrypt";

  # 11.0 grew an argon2 password hash, implemented by the vendored
  # `phc-winner-argon2`. The Makefile reaches those sources through `.PATH`,
  # so they have to be present in the filtered tree; otherwise the build stops
  # at `don't know how to make argon2.c`.
  extraPaths = [ "external/apache2/argon2" ];

  libcMinimal = true;

  outputs = [
    "out"
    "man"
  ];

  SHLIBINSTALLDIR = "$(out)/lib";
  meta.platforms = lib.platforms.netbsd;
}

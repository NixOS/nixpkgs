{
  mkDerivation,
  libcMinimal,
  include,
  libgcc,
  csu,
}:

mkDerivation {
  path = "lib/libthr";
  extraPaths = [
    "lib/libthread_db"
    "lib/libc" # needs /include + arch-specific files
    "libexec/rtld-elf"
  ];

  outputs = [
    "out"
    "man"
    "debug"
  ];

  noLibc = true;

  buildInputs = [
    libcMinimal
    include
    libgcc
  ];

  preBuild = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -B${csu}/lib"
  '';

  env.MK_TESTS = "no";
}

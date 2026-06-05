{
  symlinkJoin,
  include,
  csu,
  libcMinimal,
  libssp_nonshared,
  libgcc,
  libmd,
  libthr,
  msun,
  librpcsvc,
  libutil,
  librt,
  libcrypt,
  libelf,
  libexecinfo,
  libkvm,
  libmemstat,
  libprocstat,
  libdevstat,
  libiconvModules,
  libdl,
  i18n,
  rtld-elf,
  baseModules ? [
    include
    csu
    libcMinimal
    libssp_nonshared
    libgcc
    libmd
    libthr
    msun
    librpcsvc
    libutil
    librt
    libcrypt
    libelf
    libexecinfo
    libkvm
    libmemstat
    libprocstat
    libdevstat
    libiconvModules
    libdl
    i18n
    rtld-elf
  ],
  extraModules ? [ ],
}:

symlinkJoin {
  pname = "libc";
  inherit (libcMinimal) version;
  paths = baseModules ++ extraModules;
}

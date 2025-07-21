{
  lib,
  symlinkJoin,
  include,
  sys-headers,
  libpthread-headers,
}:

symlinkJoin {
  name = "netbsd-headers-9.2";
  paths = [
    include
    sys-headers
    libpthread-headers
  ];
  meta.platforms = lib.platforms.netbsd;
}

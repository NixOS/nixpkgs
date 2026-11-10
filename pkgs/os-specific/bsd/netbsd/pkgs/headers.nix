{
  lib,
  symlinkJoin,
  include,
  sys-headers,
  libpthread-headers,
  version,
}:

symlinkJoin {
  name = "netbsd-headers-${version}";
  paths = [
    include
    sys-headers
    libpthread-headers
  ];
  meta.platforms = lib.platforms.netbsd;
}

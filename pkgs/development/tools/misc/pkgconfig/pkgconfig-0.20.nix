{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "pkgconfig-0.20";
  builder = ./builder.sh;
  setupHook = ./setup-hook.sh;
  src = fetchurl {
    url = http://pkgconfig.freedesktop.org/releases/pkg-config-0.20.tar.gz;
    md5 = "fb42402593e4198bc252ab248dd4158b";
  };
}

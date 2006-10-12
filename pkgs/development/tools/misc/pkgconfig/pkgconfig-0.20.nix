{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "pkgconfig-0.20";
  builder = ./builder.sh;
  setupHook = ./setup-hook.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/pkg-config-0.20.tar.gz;
    md5 = "fb42402593e4198bc252ab248dd4158b";
  };
}

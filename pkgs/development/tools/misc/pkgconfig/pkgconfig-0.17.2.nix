{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "pkgconfig-0.17.2";
  builder = ./builder.sh;
  setupHook = ./setup-hook.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/pkgconfig-0.17.2.tar.gz;
    md5 = "a0829ae71b586e027183b2a1cfe0ce88";
  };
}

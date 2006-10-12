{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "pkgconfig-0.21";
  builder = ./builder.sh;
  setupHook = ./setup-hook.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/pkg-config-0.21.tar.gz;
    md5 = "476f45fab1504aac6697aa7785f0ab91";
  };
}

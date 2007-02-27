{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "pkgconfig-0.21";
  builder = ./builder.sh;
  setupHook = ./setup-hook.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/pkg-config-0.21.tar.gz;
    md5 = "476f45fab1504aac6697aa7785f0ab91";
  };

  patches = [
    # Process Requires.private properly, see
    # http://bugs.freedesktop.org/show_bug.cgi?id=4738.
    (fetchurl {
      url = http://bugs.freedesktop.org/attachment.cgi?id=8494;
      sha256 = "1pcrdbb7dypg2biy0yqc7bdxak5zii8agqljdvk7j4wbyghpqzws";
    })
  ];
}

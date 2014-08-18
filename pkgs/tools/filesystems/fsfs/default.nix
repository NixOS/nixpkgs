{stdenv, fetchurl, openssl, fuse}:

throw "It still does not build"

stdenv.mkDerivation {
  name = "fsfs-0.1.1";
  src = fetchurl {
    url = mirror://sourceforge/fsfs/fsfs-0.1.1.tar.gz;
    sha256 = "05wka9aq182li2r7gxcd8bb3rhpns7ads0k59v7w1jza60l57c74";
  };

  buildInputs = [ fuse openssl ];

  patchPhase = ''
    sed -i -e 's,CONFDIR=\(.*\),CONFDIR='$out/etc, \
      -e 's,USERCONFPREFIX=\(.*\),USERCONFPREFIX='$out/var/lib, Makefile \
      src/Makefile src/utils/Makefile
  '';

  preInstall = ''
    mkdir -p $out/etc $out/var/lib
    makeFlags="$makeFlags prefix=$out"
  '';

  meta = {
    homepage = http://fsfs.sourceforge.net/;
    description = "Secure distributed file system in user space";
    license = "GPLv2+";
  };
}

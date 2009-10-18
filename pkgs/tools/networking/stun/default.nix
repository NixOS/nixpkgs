args: with args;
stdenv.mkDerivation {
  name = "stun-0.96.dfsg-5";

  src = fetchurl {
    url = mirror://debian/pool/main/s/stun/stun_0.96.dfsg.orig.tar.gz;
    sha256 = "09bnb3p6h8fhsskdp4wrl9hhml1va0xb28fkwgyzs32q2333pgz4";
  };

  # make it compile on x86_64-linux:
  postUnpack = ''
    sed -i 's@|| defined(__i386__)@|| defined(__x86_64__) || defined(__i386__)@' stund/stun.cxx
  '';

  installPhase = ''
    ensureDir $out/{bin,man/man8,man/man1}
    cp client $out/bin/stun
    cp server $out/bin/stund
    cp debian/manpages/stund.8 $out/man/man8
    cp debian/manpages/stun.1 $out/man/man1
  '';

  patches = fetchurl {
    url = mirror://debian/pool/main/s/stun/stun_0.96.dfsg-5.diff.gz;
    sha256 = "0a6iig58zykdab89b99v1w4fn3gf2d8wz9c01vx2zvlg22gyji0l";
  };

  meta = {
    description = "stun server and test client";
    longDescription = "eg useful to debug voip trouble";
    homepage = http://sourceforge.net/projects/stun/;
    license = "Vovida 1.0"; # See any header file.
    maintainers = [args.lib.maintainers.marcweber];
    platforms = args.lib.platforms.linux;
  };
}

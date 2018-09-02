{ stdenv, fetchurl, skalibs }:

let

  version = "2.5.0.0";

in stdenv.mkDerivation rec {

  name = "s6-linux-utils-${version}";

  src = fetchurl {
    url = "https://www.skarnet.org/software/s6-linux-utils/${name}.tar.gz";
    sha256 = "04q2z71dkzahd2ppga2zikclz2qk014c23gm7rigqxjc8rs1amvq";
  };

  outputs = [ "bin" "dev" "doc" "out" ];

  dontDisableStatic = true;

  # TODO: nsss support
  configureFlags = [
    "--enable-absolute-paths"
    "--bindir=\${bin}/bin"
    "--includedir=\${dev}/include"
    "--with-sysdeps=${skalibs.lib}/lib/skalibs/sysdeps"
    "--with-include=${skalibs.dev}/include"
    "--with-lib=${skalibs.lib}/lib"
    "--with-dynlib=${skalibs.lib}/lib"
  ];

  postInstall = ''
    mkdir -p $doc/share/doc/s6-networking/
    mv doc $doc/share/doc/s6-networking/html
  '';

  meta = {
    homepage = http://www.skarnet.org/software/s6-linux-utils/;
    description = "A set of minimalistic Linux-specific system utilities";
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ pmahoney Profpatsch ];
  };

}

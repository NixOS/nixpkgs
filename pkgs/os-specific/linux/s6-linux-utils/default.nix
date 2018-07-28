{ stdenv, fetchurl, skalibs }:

let

  version = "2.4.0.2";

in stdenv.mkDerivation rec {

  name = "s6-linux-utils-${version}";

  src = fetchurl {
    url = "https://www.skarnet.org/software/s6-linux-utils/${name}.tar.gz";
    sha256 = "0245rmk7wfyyfsi4g7f0niprwlvqlwkbyjxflb8kkbvhwfdavqip";
  };

  outputs = [ "bin" "dev" "doc" "out" ];

  dontDisableStatic = true;

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

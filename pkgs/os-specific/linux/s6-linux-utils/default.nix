{ stdenv, fetchurl, skalibs }:

let

  version = "2.0.2.3";

in stdenv.mkDerivation rec {

  name = "s6-linux-utils-${version}";

  src = fetchurl {
    url = "http://www.skarnet.org/software/s6-linux-utils/${name}.tar.gz";
    sha256 = "1hwc3dmqh4cyhx9b4gd48yvjrwmfkz968rncpqc511krpfwzyngr";
  };

  dontDisableStatic = true;

  configureFlags = [
    "--includedir=\${prefix}/include"
    "--with-sysdeps=${skalibs}/lib/skalibs/sysdeps"
    "--with-include=${skalibs}/include"
    "--with-lib=${skalibs}/lib"
    "--with-dynlib=${skalibs}/lib"
  ];

  meta = {
    homepage = http://www.skarnet.org/software/s6-linux-utils/;
    description = "A set of minimalistic Linux-specific system utilities";
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ pmahoney ];
  };

}

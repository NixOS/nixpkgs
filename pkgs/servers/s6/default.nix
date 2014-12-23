{ stdenv
, execline
, fetchurl
, gnumake40
, skalibs
}:

let

  version = "2.0.0.0";

in stdenv.mkDerivation rec {

  name = "s6-${version}";

  src = fetchurl {
    url = "http://www.skarnet.org/software/s6/${name}.tar.gz";
    sha256 = "14x4l3xp152c9v34zs7nzxzacizfpp0k0lzwh40rxm0w5wz4x0ls";
  };

  dontDisableStatic = true;

  buildInputs = [ gnumake40 ];

  configureFlags = [
    "--with-sysdeps=${skalibs}/lib/skalibs/sysdeps"
    "--with-include=${skalibs}/include"
    "--with-include=${execline}/include"
    "--with-lib=${skalibs}/lib"
    "--with-lib=${execline}/lib"
    "--with-dynlib=${skalibs}/lib"
    "--with-dynlib=${execline}/lib"
  ] ++ stdenv.lib.optional stdenv.isDarwin [ "--disable-shared" ];

  preBuild = ''
    substituteInPlace "src/daemontools-extras/s6-log.c" \
      --replace '"execlineb"' '"${execline}/bin/execlineb"'
  '';

  meta = {
    homepage = http://www.skarnet.org/software/s6/;
    description = "skarnet.org's small & secure supervision software suite";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.isc;
  };

}

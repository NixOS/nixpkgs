{ stdenv
, execline
, fetchurl
, skalibs
, skarnetConfCompile
}:

let

  version = "1.1.3.2";

in stdenv.mkDerivation rec {

  name = "s6-${version}";

  src = fetchurl {
    url = "http://www.skarnet.org/software/s6/${name}.tar.gz";
    sha256 = "0djxdd3d3mlp63sjqqs0ilf8p68m86c1s98d82fl0kgaaibpsikp";
  };

  buildInputs = [ skalibs execline skarnetConfCompile ];

  sourceRoot = "admin/${name}";

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

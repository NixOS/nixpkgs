{ stdenv, pkgs, fetchurl }:

stdenv.mkDerivation rec {
  version = "1.4.24";
  name = "haproxy-${version}";
  
  src = fetchurl {
    url = "http://haproxy.1wt.eu/download/1.4/src/${name}.tar.gz";
    sha256 = "1vy7jz7l8qdd6ah3y65zarz9x9pf3bs02icxnrckpgh1s3s2h2b8";
  };

  buildInputs = [ ];

  # TODO: make it work on darwin/bsd as well
  preConfigure = ''
    export makeFlags="TARGET=linux2628 PREFIX=$out"
  '';

  meta = {
    description = "HAProxy is a free, very fast and reliable solution offering high availability, load balancing, and proxying for TCP and HTTP-based applications.";
    homepage = "http://haproxy.1wt.eu";
    maintainers = [ stdenv.lib.maintainers.garbas ];
    platforms = stdenv.lib.platforms.linux;
    license = [
       pkgs.lib.licenses.gpl2
       pkgs.lib.licenses.lgpl21
    ];
  };
}

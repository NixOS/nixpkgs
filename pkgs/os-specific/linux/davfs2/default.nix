{stdenv, fetchurl, neon, zlib}:

stdenv.mkDerivation rec {
  name = "davfs2-1.4.1";

  src = fetchurl {
    url = "http://www.very-clever.com/download/nongnu/davfs2/${name}.tar.gz";
    sha256 = "0fqq331rd3ylzfhdsbbj0b2znn3d0js0kxcv3w54dl9g2cs8fqhn";
  };

  buildInputs = [ neon zlib ]; 
  patches = [ ./davfs2-install.patch ]; 

  meta = {
    description = "Web Distributed Authoring and Versioning (WebDAV), an extension to the HTTP-protocol, allows authoring of resources on a remote web server. davfs2 provides the ability to access such resources like a typical filesystem, allowing for use by standard applications with no built-in support for WebDAV.";

    license = "GPLv3+";
    homepage = http://savannah.nongnu.org/projects/davfs2;
  };
}

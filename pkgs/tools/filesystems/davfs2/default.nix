{ stdenv, fetchurl, neon, zlib }:

stdenv.mkDerivation rec {
  name = "davfs2-1.4.5";

  src = fetchurl {
    url = "mirror://savannah/davfs2/${name}.tar.gz";
    sha256 = "1pkl2braggp2qg4c68dwfv399l9jz7cvi7gkm4xbj6mgvl0cxw18";
  };

  buildInputs = [ neon zlib ];
  
  patches = [ ./davfs2-install.patch ]; 

  meta = {
    longDescription = "Web Distributed Authoring and Versioning (WebDAV), an extension to the HTTP-protocol, allows authoring of resources on a remote web server. davfs2 provides the ability to access such resources like a typical filesystem, allowing for use by standard applications with no built-in support for WebDAV.";

    license = "GPLv3+";
    homepage = http://savannah.nongnu.org/projects/davfs2;
  };
}

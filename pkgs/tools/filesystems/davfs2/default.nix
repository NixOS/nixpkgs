{ stdenv, fetchurl, neon, zlib, noDavsUser ? false}:

stdenv.mkDerivation rec {
  name = "davfs2-1.4.7";

  src = fetchurl {
    url = "mirror://savannah/davfs2/${name}.tar.gz";
    sha256 = "0i7hrwlfzisb4l2mza1kjj9q9xxixggjplsjm339zl7828mfxh2h";
  };

  prePatch = stdenv.lib.optional noDavsUser ''
    echo "dav_user root" >> etc/davfs2.conf
    echo "dav_group root" >> etc/davfs2.conf
  '';

  buildInputs = [ neon zlib ];

  patches = [ ./davfs2-install.patch ./isdir.patch ];

  meta = {
    longDescription = "Web Distributed Authoring and Versioning (WebDAV), an extension to the HTTP-protocol, allows authoring of resources on a remote web server. davfs2 provides the ability to access such resources like a typical filesystem, allowing for use by standard applications with no built-in support for WebDAV.";

    license = "GPLv3+";
    homepage = http://savannah.nongnu.org/projects/davfs2;
  };
}

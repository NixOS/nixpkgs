{ stdenv, fetchurl, neon, zlib }:

stdenv.mkDerivation rec {
  name = "davfs2-1.5.5";

  src = fetchurl {
    url = "mirror://savannah/davfs2/${name}.tar.gz";
    sha256 = "0bxd62268pix7w1lg7f9y94v34f4l45fdf6clyarj43qmljnlz2q";
  };

  buildInputs = [ neon zlib ];

  patches = [ ./isdir.patch ./fix-sysconfdir.patch ];

  configureFlags = [ "--sysconfdir=/etc" ];

  makeFlags = ["sbindir=$(out)/sbin" "ssbindir=$(out)/sbin"];

  meta = {
    homepage = https://savannah.nongnu.org/projects/davfs2;
    description = "Mount WebDAV shares like a typical filesystem";
    license = stdenv.lib.licenses.gpl3Plus;

    longDescription = ''
      Web Distributed Authoring and Versioning (WebDAV), an extension to
      the HTTP-protocol, allows authoring of resources on a remote web
      server. davfs2 provides the ability to access such resources like
      a typical filesystem, allowing for use by standard applications
      with no built-in support for WebDAV.
    '';

    platforms = stdenv.lib.platforms.linux;
  };
}

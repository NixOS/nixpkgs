{ stdenv, fetchurl, neon, zlib }:

stdenv.mkDerivation rec {
  name = "davfs2-1.5.3";

  src = fetchurl {
    url = "mirror://savannah/davfs2/${name}.tar.gz";
    sha256 = "1x9ri19995ika89cmc56za7z3ipiizhh6zdhi4mf4p7chxzdnhrw";
  };

  buildInputs = [ neon zlib ];

  patches = [ ./isdir.patch ./fix-sysconfdir.patch ];

  configureFlags = [ "--sysconfdir=/etc" ];

  makeFlags = ["sbindir=$(out)/sbin" "ssbindir=$(out)/sbin"];

  meta = {
    homepage = http://savannah.nongnu.org/projects/davfs2;
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
    maintainers = [ stdenv.lib.maintainers.peti ];
  };
}

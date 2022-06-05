{ lib, stdenv
, fetchurl
, fetchpatch
, neon
, procps
, substituteAll
, zlib
, wrapperDir ? "/run/wrappers/bin"
}:

stdenv.mkDerivation rec {
  pname = "davfs2";
  version = "1.6.1";

  src = fetchurl {
    url = "mirror://savannah/davfs2/davfs2-${version}.tar.gz";
    sha256 = "sha256-zj65SOzlgqUck0zLDMcOZZg5FycXyv8XP2ml4q+QxcA=";
  };

  buildInputs = [ neon zlib ];

  patches = [
    ./fix-sysconfdir.patch
    (substituteAll {
      src = ./0001-umount_davfs-substitute-ps-command.patch;
      ps = "${procps}/bin/ps";
    })
    (substituteAll {
      src = ./0002-Make-sure-that-the-setuid-wrapped-umount-is-invoked.patch;
      inherit wrapperDir;
    })
  ];

  configureFlags = [ "--sysconfdir=/etc" ];

  makeFlags = [
    "sbindir=$(out)/sbin"
    "ssbindir=$(out)/sbin"
  ];

  meta = {
    homepage = "https://savannah.nongnu.org/projects/davfs2";
    description = "Mount WebDAV shares like a typical filesystem";
    license = lib.licenses.gpl3Plus;

    longDescription = ''
      Web Distributed Authoring and Versioning (WebDAV), an extension to
      the HTTP-protocol, allows authoring of resources on a remote web
      server. davfs2 provides the ability to access such resources like
      a typical filesystem, allowing for use by standard applications
      with no built-in support for WebDAV.
    '';

    platforms = lib.platforms.linux;
  };
}

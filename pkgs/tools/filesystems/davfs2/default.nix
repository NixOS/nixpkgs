{ stdenv
, fetchurl
, fetchpatch
, autoreconfHook
, neon
, procps
, substituteAll
, zlib
}:

stdenv.mkDerivation rec {
  name = "davfs2-1.5.6";

  src = fetchurl {
    url = "mirror://savannah/davfs2/${name}.tar.gz";
    sha256 = "00fqadhmhi2bmdar5a48nicmjcagnmaj9wgsvjr6cffmrz6pcx21";
  };

  nativeBuildInputs = [
    autoreconfHook # neon-0.31.patch requires reconfiguration
  ];

  buildInputs = [ neon zlib ];

  patches = [
    ./isdir.patch
    ./fix-sysconfdir.patch
    (substituteAll {
      src = ./0001-umount_davfs-substitute-ps-command.patch;
      ps = "${procps}/bin/ps";
    })

    # Fix build with neon 0.31
    # http://savannah.nongnu.org/bugs/?58101
    (fetchpatch {
      name = "neon-0.31.patch";
      url = "http://savannah.nongnu.org/bugs/download.php?file_id=48737";
      sha256 = "EtQfcstWkn8AcbZo93midGt076gq20AvGGJyQ3FO/YQ=";
      extraPrefix = ""; # empty means add 'a/' and 'b/'
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

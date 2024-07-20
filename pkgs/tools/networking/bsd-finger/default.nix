{
  lib,
  stdenv,
  fetchurl,
  fetchDebianPatch,
  buildClient ? true,
}:

stdenv.mkDerivation rec {
  srcName = "bsd-finger";
  pname = srcName + lib.optionalString (!buildClient) "d";
  version = "0.17";

  src = fetchurl {
    url = "http://ftp.de.debian.org/debian/pool/main/b/bsd-finger/bsd-finger_${version}.orig.tar.bz2";
    hash = "sha256-KLNNYF0j6mh9eeD8SMA1q+gPiNnBVH56pGeW0QgcA2M=";
  };

  debianRevision = "17";

  # outputs = [ "out" "man" ];

  env.NIX_CFLAGS_COMPILE = "-D_GNU_SOURCE";

  patches = [
    # Patches original finger sources to make the programs more robust and compatible
    (fetchDebianPatch {
      pname = srcName;
      inherit version debianRevision;
      patch = "01-legacy.patch";
      hash = "sha256-84znJLXez4w6WB2nOW+PHK/0srE0iG9nGAjO1/AGczw=";
    })

    # http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=518559
    #
    # Doesn't work with a non-iterable nsswitch source
    #
    # Currently, "finger tabbott" works by iterating through the list of users
    # on the system using getpwent and checking if any of them match "tabbott".
    #
    # Some nsswitch backends (including Hesiod and LDAP[1]) do not support
    # iterating through the complete list of users.  These nsswitch backends
    # instead only fully support looking up a user's information by username or
    # uid.
    #
    # So, if tabbott is a user whose nsswitch information comes from LDAP, then
    # "finger tabbott" will incorrectly report "finger: tabbott: no such user."
    # "finger -m tabbott" does work correctly, however, because it looks up the
    # matching username using getpwnam.
    #
    # A fix for this is to always look up an argument to finger for a username
    # match, and having -m only control whether finger searches the entire user
    # database for real name matches.  Patch attached.
    #
    # This patch has the advantageous side effect that if there are some real
    # name matches and a username match, finger will always display the username
    # match first (rather than in some random place in the list).
    #
    #     -Tim Abbott
    #
    # [1] with LDAP, it is typically the case that one can iterate through only
    # the first 100 results from a query.
    (fetchDebianPatch {
      pname = srcName;
      inherit version debianRevision;
      patch = "02-518559-nsswitch-sources.patch";
      hash = "sha256-oBXJ/kr/czevWk0TcsutGINNwCoHnEStRT8Jfgp/lbM=";
    })

    # http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=468454
    # Implement IPv6 capacity for the server Fingerd.
    (fetchDebianPatch {
      pname = srcName;
      inherit version debianRevision;
      patch = "03-468454-fingerd-ipv6.patch";
      hash = "sha256-a5+qoy2UKa2nCJrwrfJ5VPZoACFXFQ1j/rweoMYW1Z0=";
    })

    # http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=468454
    # Implement IPv6 capability for the client Finger.
    (fetchDebianPatch {
      pname = srcName;
      inherit version debianRevision;
      patch = "04-468454-finger-ipv6.patch";
      hash = "sha256-cg93NL02lJm/5Freegb3EbjDAQVkurLEEJifcyQRRfk=";
    })

    # http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=547014
    # From: "Matthew A. Dunford" <mdunford@lbl.gov>
    #
    # finger segfaults when it comes across a netgroup entry in /etc/passwd.
    # A netgroup entry doesn't include many of the fields in a normal passwd
    # entry, so pw->pw_gecos is set to NULL, which causes finger to core
    # dump.
    #
    # Here is part of a /etc/passwd file with a netgroup entry:
    #
    # nobody:x:65534:65534:nobody:/nonexistent:/bin/sh
    # +@operator
    #
    # This patch sidesteps what finger considers a malformed passwd entry:
    (fetchDebianPatch {
      pname = srcName;
      inherit version debianRevision;
      patch = "05-547014-netgroup.patch";
      hash = "sha256-d+ufp7nPZwW+t+EWASzHrXT/O6zSzt6OOV12cKVo3P0=";
    })

    # Decrease timeout length during connect().
    # In cases where a name server is answering with A as well as AAAA records,
    # but the system to be queried has lost a corresponding address, the TCP
    # handshake timeout will cause a long delay before allowing the query of
    # the next address family, or the next address in general.
    #  .
    # The use of a trivial signal handler for SIGALRM allows the reduction
    # of this timeout, thus producing better responsiveness for the interactive
    # user of the Finger service.
    # Author: Mats Erik Andersson <debian@gisladisker.se>
    (fetchDebianPatch {
      pname = srcName;
      inherit version debianRevision;
      patch = "06-572211-decrease-timeout.patch";
      hash = "sha256-KtNGU5mmX1nnxQc7XnYoUuVW4We2cF81+x6EQrHF7g0=";
    })

    # Use cmake as build system
    (fetchDebianPatch {
      pname = srcName;
      inherit version debianRevision;
      patch = "use-cmake-as-buildsystem.patch";
      hash = "sha256-YOmkF6Oxowy15mCE1pCvHKnLEXglijWFG6eydnZJFhM=";
    })

    # Debian-specific changes to the cmake build system (that NixOS will also benefit from)
    # Adds -D_GNU_SOURCE, which will enable many C extensions that finger benefits from
    (fetchDebianPatch {
      pname = srcName;
      inherit version debianRevision;
      patch = "use-cmake-as-buildsystem-debian-extras.patch";
      hash = "sha256-T3DWpyyz15JCiVJ41RrJEhsmicei8G3OaKpxvzOCcBU=";
    })

    # Fix typo at fingerd man page (Josue Ortega <josue@debian.org>)
    (fetchDebianPatch {
      pname = srcName;
      inherit version debianRevision;
      patch = "fix-fingerd-man-typo.patch";
      hash = "sha256-f59osGi0a8Tkm2Vxg2+H2brH8WproCDvbPf4jXwi6ag=";
    })
  ];

  preBuild =
    let
      srcdir = if buildClient then "finger" else "fingerd";
    in
    ''
      cd ${srcdir}
    '';

  preInstall =
    let
      bindir = if buildClient then "bin" else "sbin";
      mandir = if buildClient then "man/man1" else "man/man8";
    in
    ''
      mkdir -p $out/${bindir} $out/${mandir}
    '';

  meta = with lib; {
    description =
      if buildClient then "User information lookup program" else "Remote user information server";
    platforms = platforms.linux;
    license = licenses.bsdOriginal;
    mainProgram = "finger";
  };
}
# TODO: multiple outputs (manpage)

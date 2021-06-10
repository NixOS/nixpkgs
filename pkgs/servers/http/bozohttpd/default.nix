{ lib
, stdenv
, fetchurl
, bmake
, groff
, inetutils
, wget
, openssl
, minimal ? false
, userSupport ? !minimal
, cgiSupport ? !minimal
, dirIndexSupport ? !minimal
, dynamicContentSupport ? !minimal
, sslSupport ? !minimal
, luaSupport ? !minimal
, lua
, htpasswdSupport ? !minimal
}:

let inherit (lib) optional optionals;
in
stdenv.mkDerivation rec {
  pname = "bozohttpd";
  version = "20210227";

  # bozohttpd is developed in-tree in pkgsrc, canonical hashes can be found at:
  # http://cvsweb.netbsd.org/bsdweb.cgi/pkgsrc/www/bozohttpd/distinfo
  src = fetchurl {
    url = "http://www.eterna.com.au/${pname}/${pname}-${version}.tar.bz2";
    sha512 = "b838498626ffb7f7e84f31611e0e99aaa3af64bd9376e1a13ec16313c182eebfd9ea2c2d03904497239af723bf34a3d2202dac1f2d3e55f9fd076f6d45ccfa33";
  };

  # backport two unreleased commits to fix builds on non-netbsd platforms.
  patches = [
    # add missing `#include <stdint.h>`
    # https://freshbsd.org/netbsd/src/commit/qMGNoXfgeieZBVRC
    ./0001-include-stdint.h.patch

    # BUFSIZ is not guaranteed to be large enough
    # https://freshbsd.org/netbsd/src/commit/A4ueIHIp3JgjNVRC
    ./0002-dont-use-host-BUFSIZ.patch
  ];
  patchFlags = [ "-p3" ];

  buildInputs = [ openssl ] ++ optional (luaSupport) lua;
  nativeBuildInputs = [ bmake groff ];

  COPTS = [
    "-D_DEFAULT_SOURCE"
    "-D_GNU_SOURCE"

    # ensure that we can serve >2GB files even on 32-bit systems.
    "-D_LARGEFILE_SOURCE"
    "-D_FILE_OFFSET_BITS=64"

    # unpackaged dependency: https://man.netbsd.org/blocklist.3
    "-DNO_BLOCKLIST_SUPPORT"
  ]
  ++ optional (!userSupport) "-DNO_USER_SUPPORT"
  ++ optional (!dirIndexSupport) "-DNO_DIRINDEX_SUPPORT"
  ++ optional (!dynamicContentSupport) "-DNO_DYNAMIC_CONTENT"
  ++ optional (!luaSupport) "-DNO_LUA_SUPPORT"
  ++ optional (!sslSupport) "-DNO_SSL_SUPPORT"
  ++ optional (!cgiSupport) "-DNO_CGIBIN_SUPPORT"
  ++ optional (htpasswdSupport) "-DDO_HTPASSWD";

  _LDADD = [ "-lm" ]
    ++ optional (stdenv.hostPlatform.libc != "libSystem") "-lcrypt"
    ++ optional (luaSupport) "-llua"
    ++ optionals (sslSupport) [ "-lssl" "-lcrypto" ];
  makeFlags = [ "LDADD=$(_LDADD)" ];

  doCheck = true;
  checkInputs = [ inetutils wget ];
  checkFlags = optional (!cgiSupport) "CGITESTS=";

  meta = with lib; {
    description = "Bozotic HTTP server; small and secure";
    longDescription = ''
      bozohttpd is a small and secure HTTP version 1.1 server. Its main
      feature is the lack of features, reducing the code size and improving
      verifiability.

      It supports CGI/1.1, HTTP/1.1, HTTP/1.0, HTTP/0.9, ~user translations,
      virtual hosting support, as well as multiple IP-based servers on a
      single machine. It is capable of servicing pages via the IPv6 protocol.
      It has SSL support. It has no configuration file by design.
    '';
    homepage = "http://www.eterna.com.au/bozohttpd/";
    changelog = "http://www.eterna.com.au/bozohttpd/CHANGES";
    license = licenses.bsd2;
    maintainers = [ maintainers.embr ];
    platforms = platforms.all;
  };
}

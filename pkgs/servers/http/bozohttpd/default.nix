{ lib
, stdenv
, fetchurl
, bmake
, groff
, inetutils
, wget
, openssl
, libxcrypt
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
  version = "20240126";

  # bozohttpd is developed in-tree in pkgsrc, canonical hashes can be found at:
  # http://cvsweb.netbsd.org/bsdweb.cgi/pkgsrc/www/bozohttpd/distinfo
  src = fetchurl {
    url = "http://eterna23.net/${pname}/${pname}-${version}.tar.bz2";
    hash = "sha512-fr1PnyYAS3wkpmj/npRC3A87UL9LIXw4thlM4GfrtlJbuX5EkWGVJnHJW/EmYp7z+N91dcdRJgdO79l6WJsKpg==";
  };

  buildInputs = [ openssl libxcrypt ] ++ optional (luaSupport) lua;
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
  nativeCheckInputs = [ inetutils wget ];
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

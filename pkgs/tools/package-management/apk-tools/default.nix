{ stdenv, lib, fetchurl, lua, openssl, pkg-config, zlib }:

stdenv.mkDerivation rec {
  pname = "apk-tools";
  version = "2.10.5";

  src = fetchurl {
    url = "https://dev.alpinelinux.org/archive/apk-tools/apk-tools-${version}.tar.xz";
    sha256 = "00z3fqnv8vk2czdm4p2q4sldq0n8sxyf2qfwppyk7wj59d2sq8dp";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ lua openssl zlib ];

  makeFlags = [
    "CC=cc"
    "SBINDIR=$(out)/bin"
    "LIBDIR=$(out)/lib"
    "LUA_LIBDIR=$(out)/lib/lua/${lib.versions.majorMinor lua.version}"
    "MANDIR=$(out)/share/man"
    "DOCDIR=$(out)/share/doc/apk"
    "INCLUDEDIR=$(out)/include"
    "PKGCONFIGDIR=$(out)/lib/pkgconfig"
  ];

  NIX_CFLAGS_COMPILE = [ "-Wno-error=unused-result" ];

  enableParallelBuilding = true;

  patchPhase = lib.optionals stdenv.isDarwin ''
    substituteInPlace libfetch/common.c --replace 'MSG_NOSIGNAL' 'MSG_HAVEMORE'
    substituteInPlace src/archive.c --replace '#include <sys/sysmacros.h>' ""
    substituteInPlace src/archive.c --replace 'mknodat' "mknod"
    substituteInPlace src/common.c --replace 'malloc.h' "stdlib.h"
    substituteInPlace src/blob.c --replace 'malloc.h' "stdlib.h"
    substituteInPlace src/blob.c --replace 'memrchr' "memchr"
    substituteInPlace src/apk_defines.h --replace 'endian.h' "stdlib.h"
    substituteInPlace libfetch/http.c --replace 'strdupa' 'strdup'
  '';

  meta = with lib; {
    homepage = "https://gitlab.alpinelinux.org/alpine/apk-tools";
    description = "Alpine Package Keeper";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}

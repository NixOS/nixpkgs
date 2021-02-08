{ lib, stdenv, fetchFromGitLab, pkg-config, scdoc, openssl, zlib
, luaSupport ? stdenv.hostPlatform == stdenv.buildPlatform, lua
}:

stdenv.mkDerivation rec {
  pname = "apk-tools";
  version = "2.12.2";

  src = fetchFromGitLab {
    domain = "gitlab.alpinelinux.org";
    owner = "alpine";
    repo = "apk-tools";
    rev = "v${version}";
    sha256 = "1crx2xlswi7i0mwgzrfphpf49ghfnh79fi5dn1sl611j9sy9wa29";
  };

  nativeBuildInputs = [ pkg-config scdoc ]
    ++ lib.optionals luaSupport [ lua lua.pkgs.lua-zlib ];
  buildInputs = [ openssl zlib ] ++ lib.optional luaSupport lua;
  strictDeps = true;

  makeFlags = [
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
    "SBINDIR=$(out)/bin"
    "LIBDIR=$(out)/lib"
    "LUA=${if luaSupport then "lua" else "no"}"
    "LUA_LIBDIR=$(out)/lib/lua/${lib.versions.majorMinor lua.version}"
    "MANDIR=$(out)/share/man"
    "DOCDIR=$(out)/share/doc/apk"
    "INCLUDEDIR=$(out)/include"
    "PKGCONFIGDIR=$(out)/lib/pkgconfig"
  ];

  NIX_CFLAGS_COMPILE = [ "-Wno-error=unused-result" ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://gitlab.alpinelinux.org/alpine/apk-tools";
    description = "Alpine Package Keeper";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.gpl2Only;
    platforms = platforms.unix;
    broken = stdenv.isDarwin;
  };
}

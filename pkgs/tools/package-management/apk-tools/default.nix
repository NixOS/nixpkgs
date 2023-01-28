{ lib, stdenv, fetchFromGitLab, pkg-config, scdoc, openssl, zlib
, luaSupport ? stdenv.hostPlatform == stdenv.buildPlatform, lua
}:

stdenv.mkDerivation rec {
  pname = "apk-tools";
  version = "2.12.10";

  src = fetchFromGitLab {
    domain = "gitlab.alpinelinux.org";
    owner = "alpine";
    repo = "apk-tools";
    rev = "v${version}";
    sha256 = "sha256-VKgnnrEG1cx4cx6StWh+XaCe5meSU9LqZRH1ElMQkfk=";
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

  NIX_CFLAGS_COMPILE = [
    "-Wno-error=unused-result"
    "-Wno-error=deprecated-declarations"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://gitlab.alpinelinux.org/alpine/apk-tools";
    description = "Alpine Package Keeper";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.gpl2Only;
    platforms = platforms.linux;
  };
}

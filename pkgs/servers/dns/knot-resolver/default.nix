{ stdenv, fetchurl, pkgconfig, utillinux, vimNox, which
, knot-dns, luajit, libuv, lmdb
, cmocka, systemd, hiredis, libmemcached
, gnutls, nettle
, luajitPackages, makeWrapper
}:

let
  inherit (stdenv.lib) optional;
in
stdenv.mkDerivation rec {
  name = "knot-resolver-${version}";
  version = "1.2.0";

  src = fetchurl {
    url = "http://secure.nic.cz/files/knot-resolver/${name}.tar.xz";
    sha256 = "b8828197dbd563e4b502571538c6d44ef2bb07dede1df884b785921f8aec77fd";
  };

  outputs = [ "out" "dev" ];

  configurePhase = ":";

  nativeBuildInputs = [ pkgconfig which makeWrapper ]
    ++ [(if stdenv.isLinux then utillinux.bin/*hexdump*/ else vimNox/*xxd*/)];

  buildInputs = [ knot-dns luajit libuv gnutls ]
    # TODO: lmdb needs lmdb.pc; embedded for now
    ## optional dependencies
    ++ optional doInstallCheck cmocka
    ++ optional stdenv.isLinux systemd # socket activation
    ++ [
      nettle # DNS cookies
      hiredis libmemcached # additional cache backends
      # http://knot-resolver.readthedocs.io/en/latest/build.html#requirements
    ];

  makeFlags = [ "PREFIX=$(out)" ];
  CFLAGS = [ "-O2" "-DNDEBUG" ];

  enableParallelBuilding = true;

  doInstallCheck = true;
  installCheckTarget = "check";
  preInstallCheck = ''
    export LD_LIBRARY_PATH="$out/lib"
  '';

  # optional: to allow auto-bootstrapping root trust anchor via https
  postInstall = with luajitPackages; ''
    wrapProgram "$out/sbin/kresd" \
      --set LUA_PATH '${
        stdenv.lib.concatStringsSep ";"
          (map getLuaPath [ luasec luasocket ])
        }' \
      --set LUA_CPATH '${
        stdenv.lib.concatStringsSep ";"
          (map getLuaCPath [ luasec luasocket ])
        }'
  '';

  meta = with stdenv.lib; {
    description = "Caching validating DNS resolver, from .cz domain registry";
    homepage = https://knot-resolver.cz;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.vcunat /* upstream developer */ ];
  };
}


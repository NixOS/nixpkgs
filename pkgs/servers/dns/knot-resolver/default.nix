{ stdenv, fetchurl, pkgconfig, utillinux, hexdump, which
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
  version = "1.2.5";

  src = fetchurl {
    url = "http://secure.nic.cz/files/knot-resolver/${name}.tar.xz";
    sha256 = "30e24f9681e40c79a0aadbbfd78aaa72534dd3bca3347de89dfeae055b2c99e4";
  };

  outputs = [ "out" "dev" ];

  configurePhase = ":";

  nativeBuildInputs = [ pkgconfig which makeWrapper hexdump ];

  buildInputs = [ knot-dns luajit libuv gnutls ]
    ++ optional stdenv.isLinux lmdb # system lmdb causes some problems on Darwin
    ## optional dependencies; TODO: libedit, dnstap?
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


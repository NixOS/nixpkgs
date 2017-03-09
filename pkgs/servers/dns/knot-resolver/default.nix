{ stdenv, fetchurl, pkgconfig, utillinux, which, knot-dns, luajit, libuv, lmdb
, cmocka, systemd, hiredis, libmemcached
, gnutls, nettle
, lua51Packages, makeWrapper
}:

let
  inherit (stdenv.lib) optional;
in
stdenv.mkDerivation rec {
  name = "knot-resolver-${version}";
  version = "1.2.4";

  src = fetchurl {
    url = "http://secure.nic.cz/files/knot-resolver/${name}.tar.xz";
    sha256 = "630b2ad0bfdcf59164957a377adef8b1fddc37a58a7e1d10e76a1b497a30f036";
  };

  outputs = [ "out" "dev" ];

  configurePhase = ":";

  nativeBuildInputs = [ pkgconfig utillinux.bin/*hexdump*/ which ];
  buildInputs = [ knot-dns luajit libuv gnutls ]
    # TODO: lmdb needs lmdb.pc; embedded for now
    ## optional dependencies
    ++ optional doInstallCheck cmocka
    ++ [
      nettle # DNS cookies
      systemd # socket activation
      makeWrapper
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
  postInstall = with lua51Packages; ''
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


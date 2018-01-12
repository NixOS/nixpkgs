{ stdenv, fetchurl, pkgconfig, hexdump, which
, knot-dns, luajit, libuv, lmdb, gnutls, nettle
, cmocka, systemd, dns-root-data, makeWrapper
, extraFeatures ? false /* catch-all if defaults aren't enough */
, hiredis, libmemcached, luajitPackages
}:

let
  inherit (stdenv.lib) optional optionals optionalString;
in
stdenv.mkDerivation rec {
  name = "knot-resolver-${version}";
  version = "1.5.1";

  src = fetchurl {
    url = "http://secure.nic.cz/files/knot-resolver/${name}.tar.xz";
    sha256 = "146dcb24422ef685fb4167e3c536a838cf4101acaa85fcfa0c150eebdba78f81";
  };

  outputs = [ "out" "dev" ];

  configurePhase = ":";

  nativeBuildInputs = [ pkgconfig which makeWrapper hexdump ];

  # http://knot-resolver.readthedocs.io/en/latest/build.html#requirements
  buildInputs = [ knot-dns luajit libuv gnutls nettle lmdb ]
    ++ optional doInstallCheck cmocka
    ++ optional stdenv.isLinux systemd # sd_notify
    ++ optionals extraFeatures [
      hiredis libmemcached # additional cache backends
    ];
    ## optional dependencies; TODO: libedit, dnstap, http2 module?

  makeFlags = [ "PREFIX=$(out)" "ROOTHINTS=${dns-root-data}/root.hints" ];
  CFLAGS = [ "-O2" "-DNDEBUG" ];

  enableParallelBuilding = true;

  doCheck = true;
  doInstallCheck = true;
  preInstallCheck = ''
    patchShebangs tests/config/runtest.sh
  '';

  postInstall = ''
    rm "$out"/etc/kresd/root.hints # using system-wide instead
  ''
  # optional: to allow auto-bootstrapping root trust anchor via https
  + (with luajitPackages; ''
      wrapProgram "$out/sbin/kresd" \
        --set LUA_PATH '${
          stdenv.lib.concatStringsSep ";"
            (map getLuaPath [ luasec luasocket ])
          }' \
        --set LUA_CPATH '${
          stdenv.lib.concatStringsSep ";"
            (map getLuaCPath [ luasec luasocket ])
          }'
    '');

  meta = with stdenv.lib; {
    description = "Caching validating DNS resolver, from .cz domain registry";
    homepage = https://knot-resolver.cz;
    license = licenses.gpl3Plus;
    # Platforms using negative pointers for stack won't work ATM due to LuaJIT impl.
    platforms = filter (p: p != "aarch64-linux") platforms.unix;
    maintainers = [ maintainers.vcunat /* upstream developer */ ];
  };
}


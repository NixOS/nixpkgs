{ stdenv, fetchurl, pkgconfig, hexdump, which
, knot-dns, luajit, libuv, lmdb, gnutls, nettle
, cmocka, systemd, dns-root-data, makeWrapper
, extraFeatures ? false /* catch-all if defaults aren't enough */
, hiredis, libmemcached, luajitPackages
, fetchpatch
}:

let
  inherit (stdenv.lib) optional optionals optionalString;
in
stdenv.mkDerivation rec {
  name = "knot-resolver-${version}";
  version = "1.4.0";

  src = fetchurl {
    url = "http://secure.nic.cz/files/knot-resolver/${name}.tar.xz";
    sha256 = "ac19c121fd687c7e4f5f907b46932d26f8f9d9e01626c4dadb3847e25ea31ceb";
  };

  patches = [
    # https://gitlab.labs.nic.cz/knot/knot-resolver/blob/v1.5.2/NEWS
    (fetchurl {
      name = "CVE-2018-1000002.diff";
      url = "https://gitlab.labs.nic.cz/knot/knot-resolver/commit/f90d27de49c.diff";
      sha256 = "1j68zzb8a19kmsh3ggi7f2sghvvb60zm3yds01v2knw61bhyzh6c";
    })
    (fetchurl {
      name = "CVE-2018-1000002-part2.diff";
      url = "https://gitlab.labs.nic.cz/knot/knot-resolver/commit/d296e36eb55.diff";
      sha256 = "1yavahd7dyx8j9bdfgf46gl0swfr2835yjg8yxc4ra79x6n9mnf7";
    })
  ];

  outputs = [ "out" "dev" ];

  configurePhase = ":";

  nativeBuildInputs = [ pkgconfig which makeWrapper hexdump ];

  # http://knot-resolver.readthedocs.io/en/latest/build.html#requirements
  buildInputs = [ knot-dns luajit libuv gnutls nettle ]
    ++ optional stdenv.isLinux lmdb # system lmdb causes some problems on Darwin
    ++ optional doInstallCheck cmocka
    ++ optional stdenv.isLinux systemd # sd_notify
    ++ optionals extraFeatures [
      hiredis libmemcached # additional cache backends
    ];
    ## optional dependencies; TODO: libedit, dnstap, http2 module?

  makeFlags = [ "PREFIX=$(out)" "ROOTHINTS=${dns-root-data}/root.hints" ];
  CFLAGS = [ "-O2" "-DNDEBUG" ];

  enableParallelBuilding = true;

  doInstallCheck = true;
  installCheckTarget = "check";
  preInstallCheck = ''
    export LD_LIBRARY_PATH="$out/lib"
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


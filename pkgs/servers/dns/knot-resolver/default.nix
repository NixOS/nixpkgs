{ stdenv, fetchurl, runCommand, pkgconfig, hexdump, which
, knot-dns, luajit, libuv, lmdb, gnutls, nettle
, cmocka, systemd, dns-root-data, makeWrapper
, extraFeatures ? false /* catch-all if defaults aren't enough */
, hiredis, libmemcached, luajitPackages
}:
let # un-indented, over the whole file

result = if extraFeatures then wrapped-full else unwrapped;

inherit (stdenv.lib) optional optionals optionalString concatStringsSep;

unwrapped = stdenv.mkDerivation rec {
  name = "knot-resolver-${version}";
  version = "2.2.0";

  src = fetchurl {
    url = "http://secure.nic.cz/files/knot-resolver/${name}.tar.xz";
    sha256 = "1yhlwvpl81klyfb8hhvrhii99q7wvydi3vandmq9j7dvig6z1dvv";
  };

  outputs = [ "out" "dev" ];

  configurePhase = "patchShebangs scripts/";

  nativeBuildInputs = [ pkgconfig which hexdump ];

  # http://knot-resolver.readthedocs.io/en/latest/build.html#requirements
  buildInputs = [ knot-dns luajit libuv gnutls nettle lmdb ]
    ++ optional doCheck cmocka
    ++ optional stdenv.isLinux systemd # sd_notify
    ## optional dependencies; TODO: libedit, dnstap
    ;

  makeFlags = [
    "PREFIX=$(out)"
    "ROOTHINTS=${dns-root-data}/root.hints"
    "KEYFILE_DEFAULT=${dns-root-data}/root.ds"
  ];
  CFLAGS = [ "-O2" "-DNDEBUG" ];

  enableParallelBuilding = true;

  doCheck = true;
  doInstallCheck = false; # FIXME
  preInstallCheck = ''
    patchShebangs tests/config/runtest.sh
  '';

  postInstall = ''
    rm "$out"/etc/knot-resolver/root.hints # using system-wide instead
  '';

  meta = with stdenv.lib; {
    description = "Caching validating DNS resolver, from .cz domain registry";
    homepage = https://knot-resolver.cz;
    license = licenses.gpl3Plus;
    # Platforms using negative pointers for stack won't work ATM due to LuaJIT impl.
    platforms = filter (p: p != "aarch64-linux") platforms.unix;
    maintainers = [ maintainers.vcunat /* upstream developer */ ];
  };
};

wrapped-full = with luajitPackages; let
    luaPkgs =  [ luasec luasocket ]; # TODO: cqueues and others for http2 module
  in runCommand unwrapped.name
  {
    nativeBuildInputs = [ makeWrapper ];
    preferLocalBuild = true;
    allowSubstitutes = false;
  }
  ''
    mkdir -p "$out/sbin" "$out/share"
    makeWrapper '${unwrapped}/sbin/kresd' "$out"/sbin/kresd \
      --set LUA_PATH  '${concatStringsSep ";" (map getLuaPath  luaPkgs)}' \
      --set LUA_CPATH '${concatStringsSep ";" (map getLuaCPath luaPkgs)}'
    ln -sr '${unwrapped}/share/man' "$out"/share/
    ln -sr "$out"/{sbin,bin}
  '';

in result

